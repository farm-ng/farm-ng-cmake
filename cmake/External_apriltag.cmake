ExternalProject_Add(apriltag
    DEPENDS
    PREFIX ${farm_ng_EXT_PREFIX}
    GIT_REPOSITORY https://github.com/AprilRobotics/apriltag
    GIT_TAG v3.3.0
    CMAKE_ARGS
    ${farm_ng_DEFAULT_ARGS}
    -DCMAKE_BUILD_TYPE=Release
    TEST_BEFORE_INSTALL OFF
)
