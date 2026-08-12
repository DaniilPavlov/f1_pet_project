import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:f1_pet_project/services/cache/zlib/cache_zlib_library_io.dart';
import 'package:ffi/ffi.dart';

/// Префикс envelope в SharedPreferences (`z1:` + base64).
/// Должен совпадать с [kZlibCacheEnvelopePrefix] в `cache_payload_codec.dart`.
const _envelopePrefix = 'z1:';

/// Ручные FFI-биндинги к символам из `native/cache_zlib`.
///
/// Пары typedef:
/// - `*Native` — сигнатура на стороне C (`Int32`, `Pointer`, `Size`);
/// - `*Dart` — то, что получает Dart после `.asFunction()` (`int`, …).
///
/// `lookup` падает с [ArgumentError], если символа нет в [DynamicLibrary]
/// (например, iOS dead-strip без `-Wl,-u,_cache_zlib_*`).
final class CacheZlibBindings {
  CacheZlibBindings(DynamicLibrary library)
    : compress = library
          .lookup<NativeFunction<CacheZlibCompressNative>>('cache_zlib_compress')
          .asFunction(),
      decompress = library
          .lookup<NativeFunction<CacheZlibDecompressNative>>('cache_zlib_decompress')
          .asFunction(),
      free = library.lookup<NativeFunction<CacheZlibFreeNative>>('cache_zlib_free').asFunction();

  final CacheZlibCompressDart compress;
  final CacheZlibDecompressDart decompress;
  final CacheZlibFreeDart free;
}

// --- Native / Dart typedefs (ABI) -------------------------------------------

typedef CacheZlibCompressNative =
    Int32 Function(Pointer<Uint8> src, Size srcLen, Pointer<Pointer<Uint8>> dst, Pointer<Size> dstLen);
typedef CacheZlibCompressDart =
    int Function(Pointer<Uint8> src, int srcLen, Pointer<Pointer<Uint8>> dst, Pointer<Size> dstLen);

typedef CacheZlibDecompressNative =
    Int32 Function(
      Pointer<Uint8> src,
      Size srcLen,
      Size uncompressedLen,
      Pointer<Pointer<Uint8>> dst,
      Pointer<Size> dstLen,
    );
typedef CacheZlibDecompressDart =
    int Function(
      Pointer<Uint8> src,
      int srcLen,
      int uncompressedLen,
      Pointer<Pointer<Uint8>> dst,
      Pointer<Size> dstLen,
    );

typedef CacheZlibFreeNative = Void Function(Pointer<Uint8> ptr);
typedef CacheZlibFreeDart = void Function(Pointer<Uint8> ptr);

/// Высокоуровневый вызов zlib через FFI с явным владением native-буфером.
///
/// Паттерн на каждый вызов:
/// 1. [using] / [Arena] — временные указатели (src, out-параметры), живут до конца
///    колбэка и освобождаются arena-аллокатором Dart.
/// 2. Native `malloc` для результата compress/decompress — **не** arena;
///    после копирования в [Uint8List] обязательно [_bindings.free].
/// 3. Код возврата `0` == `Z_OK`; иначе [StateError].
final class CacheZlib {
  CacheZlib(this._bindings);

  final CacheZlibBindings _bindings;

  /// Открывает библиотеку и резолвит символы; `null`, если dylib/so недоступна
  /// или `lookup` не нашёл функции.
  static CacheZlib? tryOpen({String? libraryPath}) {
    final library = openCacheZlibLibrary(libraryPath: libraryPath);
    if (library == null) {
      return null;
    }
    try {
      return CacheZlib(CacheZlibBindings(library));
    } on Object {
      return null;
    }
  }

  /// Сжимает [input]; возвращает копию zlib-байтов в Dart heap.
  Uint8List compress(Uint8List input) {
    return using((arena) {
      final src = arena<Uint8>(input.length);
      src.asTypedList(input.length).setAll(0, input);

      final dstPtr = arena<Pointer<Uint8>>();
      final dstLen = arena<Size>();
      final rc = _bindings.compress(src, input.length, dstPtr, dstLen);
      if (rc != 0) {
        throw StateError('cache_zlib_compress failed with code $rc');
      }

      final out = dstPtr.value;
      final length = dstLen.value;
      try {
        // Копия обязательна: после free native-память невалидна.
        return Uint8List.fromList(out.asTypedList(length));
      } finally {
        _bindings.free(out);
      }
    });
  }

  /// Распаковывает zlib-payload в буфер ровно [uncompressedLength] байт
  /// (длина заранее известна из envelope).
  Uint8List decompress(Uint8List input, {required int uncompressedLength}) {
    if (uncompressedLength <= 0) {
      throw ArgumentError.value(uncompressedLength, 'uncompressedLength');
    }
    return using((arena) {
      final src = arena<Uint8>(input.length);
      src.asTypedList(input.length).setAll(0, input);

      final dstPtr = arena<Pointer<Uint8>>();
      final dstLen = arena<Size>();
      final rc = _bindings.decompress(src, input.length, uncompressedLength, dstPtr, dstLen);
      if (rc != 0) {
        throw StateError('cache_zlib_decompress failed with code $rc');
      }

      final out = dstPtr.value;
      final length = dstLen.value;
      try {
        return Uint8List.fromList(out.asTypedList(length));
      } finally {
        _bindings.free(out);
      }
    });
  }
}

/// Кодек для SharedPreferences: UTF-8 JSON ↔ envelope `z1:` + base64.
///
/// Формат бинарного blob до base64:
/// ```
/// [0..3]  uint32 big-endian — длина несжатого UTF-8
/// [4..]   zlib (compress2) payload
/// ```
/// Длина нужна на decode: `uncompress` требует точный размер выходного буфера.
///
/// Значения **без** префикса `z1:` считаются legacy plain JSON и возвращаются
/// как есть (миграция после обновления приложения).
final class FfiZlibCacheCodec {
  FfiZlibCacheCodec(this._zlib);

  static const prefix = _envelopePrefix;

  final CacheZlib _zlib;

  static FfiZlibCacheCodec? tryCreate({String? libraryPath}) {
    final zlib = CacheZlib.tryOpen(libraryPath: libraryPath);
    if (zlib == null) {
      return null;
    }
    return FfiZlibCacheCodec(zlib);
  }

  String encode(String utf8Json) {
    final raw = utf8.encode(utf8Json);
    final compressed = _zlib.compress(Uint8List.fromList(raw));
    final envelope = ByteData(4 + compressed.length)..setUint32(0, raw.length, Endian.big);
    final bytes = envelope.buffer.asUint8List()..setRange(4, 4 + compressed.length, compressed);
    return '$prefix${base64Encode(bytes)}';
  }

  /// Декодирует [stored] в JSON-текст.
  String decode(String stored) {
    if (!stored.startsWith(prefix)) {
      return stored;
    }
    final decoded = base64Decode(stored.substring(prefix.length));
    if (decoded.length < 4) {
      throw const FormatException('zlib cache envelope too short');
    }
    final rawLen = ByteData.sublistView(decoded).getUint32(0, Endian.big);
    final payload = Uint8List.sublistView(decoded, 4);
    final inflated = _zlib.decompress(payload, uncompressedLength: rawLen);
    return utf8.decode(inflated);
  }
}
