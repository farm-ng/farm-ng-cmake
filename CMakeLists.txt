cmake_minimum_required(VERSION 3.16)
# don't update VERSION here, its in the farm_ng_cmakeConfigVersion.cmake file
project(farm_ng_cmake)

# NOTE assumes that cmake is a flat directory
file(GLOB FARM_NG_CMAKE_FILES "${CMAKE_CURRENT_SOURCE_DIR}/cmake/*")

install(FILES
    ${FARM_NG_CMAKE_FILES}
    DESTINATION
        share/farm_ng_cmake/cmake
    )
