#include "cache_zlib.h"

#include <stdlib.h>
#include <zlib.h>

/*
 * Implementation notes:
 * - Uses classic zlib helpers (compress2 / uncompress), not raw inflate streams.
 * - compressBound() sizes the temporary buffer; we return only the used length.
 * - decompress requires the exact uncompressed size from the Dart envelope so
 *   we can allocate once (no grow-loop) and verify the result length.
 */

int cache_zlib_compress(
    const uint8_t* src,
    size_t src_len,
    uint8_t** dst,
    size_t* dst_len) {
  if (dst == NULL || dst_len == NULL) {
    return Z_STREAM_ERROR;
  }
  *dst = NULL;
  *dst_len = 0;

  if (src == NULL && src_len != 0) {
    return Z_STREAM_ERROR;
  }

  uLong bound = compressBound((uLong)src_len);
  uint8_t* buffer = (uint8_t*)malloc((size_t)bound);
  if (buffer == NULL) {
    return Z_MEM_ERROR;
  }

  uLongf compressed_len = bound;
  const int rc = compress2(
      buffer,
      &compressed_len,
      src,
      (uLong)src_len,
      Z_DEFAULT_COMPRESSION);
  if (rc != Z_OK) {
    free(buffer);
    return rc;
  }

  *dst = buffer;
  *dst_len = (size_t)compressed_len;
  return Z_OK;
}

int cache_zlib_decompress(
    const uint8_t* src,
    size_t src_len,
    size_t uncompressed_len,
    uint8_t** dst,
    size_t* dst_len) {
  if (dst == NULL || dst_len == NULL) {
    return Z_STREAM_ERROR;
  }
  *dst = NULL;
  *dst_len = 0;

  if ((src == NULL && src_len != 0) || uncompressed_len == 0) {
    return Z_STREAM_ERROR;
  }

  uint8_t* buffer = (uint8_t*)malloc(uncompressed_len);
  if (buffer == NULL) {
    return Z_MEM_ERROR;
  }

  uLongf out_len = (uLongf)uncompressed_len;
  const int rc = uncompress(buffer, &out_len, src, (uLong)src_len);
  if (rc != Z_OK || out_len != (uLongf)uncompressed_len) {
    free(buffer);
    return rc != Z_OK ? rc : Z_DATA_ERROR;
  }

  *dst = buffer;
  *dst_len = (size_t)out_len;
  return Z_OK;
}

void cache_zlib_free(uint8_t* ptr) {
  free(ptr);
}
