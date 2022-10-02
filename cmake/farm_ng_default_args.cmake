set(farm_ng_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/prefix")
set(farm_ng_EXT_PREFIX "${CMAKE_BINARY_DIR}/ext")
set(BUILD_SHARED_LIBS ON)

set(farm_ng_PREFIX_ARGS
  "-DCMAKE_PREFIX_PATH:PATH=${farm_ng_INSTALL_PREFIX};${CMAKE_PREFIX_PATH}"
  "-DCMAKE_INSTALL_PREFIX:PATH=${farm_ng_INSTALL_PREFIX}"
)

set(farm_ng_DEFAULT_ARGS
  "-DCMAKE_CXX_COMPILER_LAUNCHER:PATH=ccache"
  "-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}"
  "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
  ${farm_ng_PREFIX_ARGS}
)

include(ExternalProject)
