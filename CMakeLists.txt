cmake_minimum_required(VERSION 3.16)
project(farm_ng_cmake 0.1.1)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(farm_ng_module)


# NOTE assumes that cmake is a flat directory
file(GLOB FARM_NG_CMAKE_FILES "${CMAKE_CURRENT_SOURCE_DIR}/cmake/*")

install(FILES
    ${FARM_NG_CMAKE_FILES}
    DESTINATION
        share/farm_ng_cmake/cmake
    )
