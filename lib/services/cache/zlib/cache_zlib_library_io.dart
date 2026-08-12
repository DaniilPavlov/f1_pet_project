import 'dart:ffi';
import 'dart:io';

/// Загрузка native-библиотеки `f1_cache_zlib` под разные платформы.
///
/// | Платформа | Как открываем |
/// |-----------|----------------|
/// | Android   | `DynamicLibrary.open('libf1_cache_zlib.so')` — .so из CMake/NDK |
/// | iOS       | `DynamicLibrary.process()` — символы слинкованы в Runner |
/// | macOS/Linux (тесты) | путь из [libraryPath] / env `F1_CACHE_ZLIB_LIB`, иначе имя dylib/so |
///
/// Возвращает `null` вместо исключения: отсутствие native-кода (или web via
/// stub) не должно ронять приложение — [CachePayloadCodec] уйдёт в identity.
DynamicLibrary? openCacheZlibLibrary({String? libraryPath}) {
  try {
    final override = libraryPath ?? Platform.environment['F1_CACHE_ZLIB_LIB'];
    if (override != null && override.isNotEmpty) {
      return DynamicLibrary.open(override);
    }
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libf1_cache_zlib.so');
    }
    if (Platform.isIOS) {
      // Символы должны остаться после dead-strip: см. OTHER_LDFLAGS -Wl,-u,_… в Xcode.
      return DynamicLibrary.process();
    }
    if (Platform.isMacOS) {
      return DynamicLibrary.open('libf1_cache_zlib.dylib');
    }
    if (Platform.isLinux) {
      return DynamicLibrary.open('libf1_cache_zlib.so');
    }
  } on Object {
    return null;
  }
  return null;
}
