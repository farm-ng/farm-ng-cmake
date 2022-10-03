ExternalProject_Add(farm-ng-core
    DEPENDS fmt expected eigen
    PREFIX ${farm_ng_EXT_PREFIX}
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/farm-ng-core
    BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/farm-ng-core-build
    CMAKE_ARGS
        ${farm_ng_DEFAULT_ARGS}
        -DFARM_NG_BUILD_PROTOS=On
        -Dfarm_ng_cmake_DIR=${farm_ng_cmake_DIR}
    TEST_BEFORE_INSTALL ON
)
