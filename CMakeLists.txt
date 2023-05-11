cmake_minimum_required(VERSION 3.16)
# https://semver.org/
project(farm_ng_all VERSION 0.0.1)

if(NOT "$ENV{VIRTUAL_ENV}/prefix" STREQUAL "$ENV{CMAKE_PREFIX_PATH}")
  message(FATAL_ERROR "CMAKE_PREFIX_PATH does not match current VIRTUAL_ENV path.\n"
    "ENV{CMAKE_PREFIX_PATH}: '$ENV{CMAKE_PREFIX_PATH}'\n"
    "ENV{VIRTUAL_ENV}/prefix: '$ENV{VIRTUAL_ENV}/prefix'\n"
    "Did you forget to activate your virtual environment before running cmake?\n"
    "# If your venv doesn't exist yet, run:\n"
    "> ${CMAKE_CURRENT_SOURCE_DIR}/bootstrap_venv.sh\n"
    "# To active your existing VENV, run:\n"
    "> source ${CMAKE_CURRENT_SOURCE_DIR}/venv/bin/activate\n"
    "# If using an IDE, launch it from the terminal after activating.\n"
    )
endif()

set(CMAKE_PREFIX_PATH $ENV{CMAKE_PREFIX_PATH} CACHE STRING "" FORCE)
option(BUILD_FOR_AMIGA "Build only Amiga related components" OFF)
if(BUILD_FOR_AMIGA)
    message(STATUS "Building subset of project for Amiga platform")
    set(FARM_NG_BUILD_TESTS=OFF)
endif()


set(farm_ng_cmake_DIR ${CMAKE_CURRENT_SOURCE_DIR}/farm_ng_cmake/cmake)
set(Pangolin_DIR ${CMAKE_CURRENT_BINARY_DIR}/Pangolin)
find_package(farm_ng_cmake REQUIRED)
add_subdirectory(farm_ng_core)
add_subdirectory(Sophus)
add_subdirectory(Pangolin)
add_subdirectory(farm_ng_amiga)
add_subdirectory(farm_ng_lk)
if(NOT BUILD_FOR_AMIGA)
add_subdirectory(farm_ng_spice)
endif()
