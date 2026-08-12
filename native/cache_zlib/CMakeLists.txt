cmake_minimum_required(VERSION 3.18)
project(f1_cache_zlib C)

# Shared library loaded by Dart FFI (Android .so / host dylib for tests).
# iOS links cache_zlib.c into the Runner binary instead of this target.

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_VISIBILITY_PRESET hidden)

add_library(f1_cache_zlib SHARED
  src/cache_zlib.c
)

target_include_directories(f1_cache_zlib
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

find_package(ZLIB)
if(ZLIB_FOUND)
  target_link_libraries(f1_cache_zlib PRIVATE ZLIB::ZLIB)
else()
  # Android NDK exposes zlib as `libz`.
  find_library(ZLIB_LIB z REQUIRED)
  target_link_libraries(f1_cache_zlib PRIVATE ${ZLIB_LIB})
endif()

# Host / desktop builds for unit tests (macOS/Linux).
if(NOT ANDROID)
  set_target_properties(f1_cache_zlib PROPERTIES
    OUTPUT_NAME f1_cache_zlib
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
  )
endif()
