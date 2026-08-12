import 'package:f1_pet_project/services/cache/zlib/ffi_codec_stub.dart'
    if (dart.library.io) 'package:f1_pet_project/services/cache/zlib/ffi_codec_io.dart'
    as ffi_codec;
import 'package:flutter/foundation.dart';

/// Маркер zlib-envelope в SharedPreferences (`z1:` + base64).
///
/// Совпадает с префиксом в [FfiZlibCacheCodec]; вынесен сюда, чтобы web/stub
/// код мог проверять формат **без** импорта `dart:ffi`.
const kZlibCacheEnvelopePrefix = 'z1:';

/// Кодек дисковых payload'ов Jolpica-кэша ([CacheInterceptor]).
///
/// Зачем абстракция:
/// - прод: сжатие через Dart FFI → native zlib;
/// - web / unit-тесты без dylib: [IdentityCacheCodec];
/// - тесты interceptor'а: любой fake codec через конструктор.
///
/// Conditional import [ffi_codec]: на IO подключается реализация с `dart:ffi`,
/// на web — stub, который всегда возвращает `null` (сборка без FFI).
abstract class CachePayloadCodec {
  const CachePayloadCodec();

  /// JSON-текст → строка для `SharedPreferences.setString`.
  String encode(String utf8Json);

  /// Строка из prefs → JSON-текст.
  ///
  /// Сжатые значения — envelope `z1:…`; legacy plain JSON проходит без изменений.
  String decode(String stored);

  /// Платформенный дефолт: FFI zlib, если библиотека загрузилась, иначе identity.
  factory CachePayloadCodec.platform() {
    if (kIsWeb) {
      return const IdentityCacheCodec();
    }
    return ffi_codec.tryCreateFfiCachePayloadCodec() ?? const IdentityCacheCodec();
  }
}

/// Passthrough без сжатия (web, тесты, отсутствие native lib).
///
/// Намеренно **не** умеет читать `z1:` — на web/identity нет zlib; такой payload
/// считается ошибкой конфигурации, а не тихим битым кэшем.
@immutable
final class IdentityCacheCodec extends CachePayloadCodec {
  const IdentityCacheCodec();

  @override
  String encode(String utf8Json) => utf8Json;

  @override
  String decode(String stored) {
    if (stored.startsWith(kZlibCacheEnvelopePrefix)) {
      throw UnsupportedError('Compressed cache payload requires native zlib FFI');
    }
    return stored;
  }
}
