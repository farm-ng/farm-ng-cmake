ExternalProject_Add(libdatachannel
    GIT_REPOSITORY  "https://github.com/paullouisageneau/libdatachannel"
    GIT_TAG "v0.18.3"
    GIT_SHALLOW ON
    PREFIX ${farm_ng_EXT_PREFIX}
    CMAKE_ARGS
    ${farm_ng_DEFAULT_ARGS}
    -DCMAKE_BUILD_TYPE=Release
    )
