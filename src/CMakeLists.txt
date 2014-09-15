project(yuni-bootstrap-sample)
cmake_minimum_required(VERSION 2.8.10)


include("cmake/messages.cmake")

nmessage("Nany Compiler Suite c++/bootstrap")
include("cmake/utils.cmake")


if ("${CMAKE_BUILD_TYPE}" STREQUAL "" OR (NOT "${CMAKE_BUILD_TYPE}" STREQUAL "release" AND NOT "${CMAKE_BUILD_TYPE}" STREQUAL "debug"))
	# release by default
	set(CMAKE_BUILD_TYPE "debug")
endif()
nmessage("configuration: ${CMAKE_BUILD_TYPE}")




configure_file("cmake/yuni-profilebuild-template.cmake" "ext/yuni/src/ProfileBuild.cmake")
add_subdirectory("ext/yuni/src")
include_directories("ext/yuni/src")

set(EXECUTABLE_OUTPUT_PATH "${CMAKE_CURRENT_SOURCE_DIR}")





#
# Compilation Flags
#

file(READ "${CMAKE_CURRENT_SOURCE_DIR}/ext/yuni/src/compiler-flags-debug-cc"    YN_FLAGS_C_DEBUG)
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/ext/yuni/src/compiler-flags-release-cc"  YN_FLAGS_C_RELEASE)
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/ext/yuni/src/compiler-flags-debug-cxx"   YN_FLAGS_CXX_DEBUG)
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/ext/yuni/src/compiler-flags-release-cxx" YN_FLAGS_CXX_RELEASE)

set(CMAKE_C_FLAGS_DEBUG     "${YN_FLAGS_C_DEBUG}")
set(CMAKE_C_FLAGS_RELEASE   "${YN_FLAGS_C_RELEASE}")
set(CMAKE_CXX_FLAGS_DEBUG   "${YN_FLAGS_CXX_DEBUG}")
set(CMAKE_CXX_FLAGS_RELEASE "${YN_FLAGS_CXX_RELEASE}")


#
# config.h
#
message(STATUS "generating config.h")
configure_file("cmake/config.h.cmake" "config.h")



add_executable(sample  main.cpp logs.cpp logs.h)
target_link_libraries(sample  yuni-static-core)

