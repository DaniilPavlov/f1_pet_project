#ifndef F1_CACHE_ZLIB_H_
#define F1_CACHE_ZLIB_H_

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32)
#define CACHE_ZLIB_EXPORT __declspec(dllexport)
#else
/* Visible to Dart FFI: Android .so export / iOS DynamicLibrary.process(). */
#define CACHE_ZLIB_EXPORT __attribute__((visibility("default")))
#endif

/*
 * Thin zlib wrapper for Dart FFI (Jolpica SharedPreferences cache).
 *
 * Ownership contract (important for FFI):
 *   - On success, *dst is a malloc'd buffer of *dst_len bytes.
 *   - Dart must call cache_zlib_free(*dst) after copying into a Uint8List.
 *   - On failure, returns a zlib error code (non-zero) and leaves *dst = NULL.
 *
 * Why not expose raw compress()/uncompress() to Dart?
 *   - Stable ABI surface (three symbols only).
 *   - Centralizes malloc/free so Dart never frees with the wrong allocator.
 */

/// Compresses [src_len] bytes at [src] (zlib compress2, Z_DEFAULT_COMPRESSION).
CACHE_ZLIB_EXPORT int cache_zlib_compress(
    const uint8_t* src,
    size_t src_len,
    uint8_t** dst,
    size_t* dst_len);

/// Decompresses zlib payload into a buffer of exactly [uncompressed_len] bytes.
///
/// [uncompressed_len] must match the length stored in the Dart envelope
/// (big-endian u32 before the zlib bytes). Mismatch → Z_DATA_ERROR.
CACHE_ZLIB_EXPORT int cache_zlib_decompress(
    const uint8_t* src,
    size_t src_len,
    size_t uncompressed_len,
    uint8_t** dst,
    size_t* dst_len);

/// Frees a buffer returned by compress/decompress (safe with NULL).
CACHE_ZLIB_EXPORT void cache_zlib_free(uint8_t* ptr);

#ifdef __cplusplus
}
#endif

#endif  // F1_CACHE_ZLIB_H_
