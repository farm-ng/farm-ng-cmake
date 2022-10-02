cmake_minimum_required(VERSION 3.16)
project(farm_ng_cmake)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(farm_ng_module)

install(DIRECTORY
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake
    DESTINATION
        share/farm_ng_cmake
    )
