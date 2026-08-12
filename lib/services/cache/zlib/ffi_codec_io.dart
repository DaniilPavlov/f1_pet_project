import 'package:f1_pet_project/services/cache/cache_payload_codec.dart';
import 'package:f1_pet_project/services/cache/zlib/cache_zlib.dart';

/// IO-ветка conditional import: пытается поднять FFI zlib и обернуть в [CachePayloadCodec].
///
/// [libraryPath] — для unit-тестов / host dylib (`F1_CACHE_ZLIB_LIB`).
CachePayloadCodec? tryCreateFfiCachePayloadCodec({String? libraryPath}) {
  final codec = FfiZlibCacheCodec.tryCreate(libraryPath: libraryPath);
  if (codec == null) {
    return null;
  }
  return FfiCachePayloadCodec(codec);
}

/// Адаптер [FfiZlibCacheCodec] → [CachePayloadCodec] для [CacheInterceptor].
final class FfiCachePayloadCodec extends CachePayloadCodec {
  FfiCachePayloadCodec(this._inner);

  final FfiZlibCacheCodec _inner;

  @override
  String encode(String utf8Json) => _inner.encode(utf8Json);

  @override
  String decode(String stored) => _inner.decode(stored);
}
