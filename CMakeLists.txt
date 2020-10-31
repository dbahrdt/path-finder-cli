cmake_minimum_required(VERSION 3.13.4)
project(master_arbeit)

set(CMAKE_CXX_STANDARD 20)

if( NOT CMAKE_BUILD_TYPE )
    set( CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_MODULE_PATH
        ${CMAKE_CURRENT_SOURCE_DIR}/cmake/
        ${CMAKE_CURRENT_SOURCE_DIR}/vendor/liboscar/cmake/
        ${CMAKE_CURRENT_SOURCE_DIR}/vendor/liboscar/vendor/sserialize/cmake/
        )
include(add_buildtype_lto)
include(add_buildtype_ultra)
include(add_buildtype_ultra_sanitize)
include(add_buildtype_sanitize_debug)

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

add_subdirectory(vendor/path_finder)
add_subdirectory(vendor/oscar-routing)

add_executable(file_creator FileCreator.cpp CLI11.hpp)
add_executable(run_from_files RunFromFiles.cpp)

target_link_libraries(file_creator PRIVATE path_finder oscar-routing Threads::Threads)
target_link_libraries(run_from_files PRIVATE path_finder oscar-routing Threads::Threads)
