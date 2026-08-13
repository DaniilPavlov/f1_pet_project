import 'dart:io';

import 'package:f1_pet_project/services/cache/zlib/cache_zlib.dart';
import 'package:flutter_test/flutter_test.dart';

/// Интеграционный smoke FFI: нужен host dylib (`build/cache_zlib/…` или `F1_CACHE_ZLIB_LIB`).
/// Без библиотеки тест no-op (не валит CI на машинах без native build).
void main() {
  test('FFI zlib round-trip + size reduction on JSON-like payload', () {
    final libPath = _resolveHostLib();
    final native = CacheZlib.tryOpen(libraryPath: libPath);
    if (native == null) {
      // ignore: avoid_print
      print(
        'SKIP: build host lib first:\n'
        '  cmake -S native/cache_zlib -B build/cache_zlib && cmake --build build/cache_zlib\n'
        'then re-run, or set F1_CACHE_ZLIB_LIB to the dylib path.',
      );
      return;
    }

    final codec = FfiZlibCacheCodec(native);
    final json =
        '{"MRData":{"xmlns":"http://ergast.com/mrd/1.0","series":"f1","total":"20",'
        '"StandingsTable":{"season":"2024","StandingsLists":[{"round":"1","DriverStandings":['
        '{"position":"1","points":"25","Driver":{"driverId":"max_verstappen","givenName":"Max",'
        '"familyName":"Verstappen"}},{"position":"2","points":"18","Driver":{"driverId":"norris",'
        '"givenName":"Lando","familyName":"Norris"}}]}]}}}';

    final encoded = codec.encode(json);
    expect(encoded.startsWith(FfiZlibCacheCodec.prefix), isTrue);
    expect(encoded.length, lessThan(json.length));

    final decoded = codec.decode(encoded);
    expect(decoded, json);

    // Legacy plain JSON still round-trips.
    expect(codec.decode(json), json);
  });
}

String? _resolveHostLib() {
  final fromEnv = Platform.environment['F1_CACHE_ZLIB_LIB'];
  if (fromEnv != null && fromEnv.isNotEmpty && File(fromEnv).existsSync()) {
    return fromEnv;
  }

  for (final relative in <String>[
    'build/cache_zlib/libf1_cache_zlib.dylib',
    'build/cache_zlib/libf1_cache_zlib.so',
    'build/cache_zlib/Debug/libf1_cache_zlib.dylib',
    'build/cache_zlib/Release/libf1_cache_zlib.dylib',
  ]) {
    final file = File(relative);
    if (file.existsSync()) {
      return file.absolute.path;
    }
  }
  return null;
}
