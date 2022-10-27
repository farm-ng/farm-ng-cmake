ExternalProject_Add(fmt
    GIT_REPOSITORY  "https://github.com/fmtlib/fmt.git"
    GIT_TAG "9.1.0"
    PREFIX ${farm_ng_EXT_PREFIX}
    CMAKE_ARGS
    ${farm_ng_DEFAULT_ARGS}
    -DCMAKE_BUILD_TYPE=Release
    -DFMT_TEST:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=ON
    )
