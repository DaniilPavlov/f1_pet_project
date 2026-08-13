cmake_minimum_required(VERSION 3.18)

# Pulls in native/cache_zlib → libf1_cache_zlib.so for Dart DynamicLibrary.open.
add_subdirectory(
  ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../native/cache_zlib
  ${CMAKE_CURRENT_BINARY_DIR}/cache_zlib
)
