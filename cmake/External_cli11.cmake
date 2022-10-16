ExternalProject_Add(cli11
  GIT_REPOSITORY  https://github.com/CLIUtils/CLI11
  GIT_TAG "4af78beef777e313814b4daff70e2da9171a385a"
  PREFIX ${farm_ng_EXT_PREFIX}
  CMAKE_ARGS
    ${farm_ng_DEFAULT_ARGS}
    -DCLI11_BUILD_TESTS=OFF
    -DCLI11_BUILD_EXAMPLES=OFF
    -DCMAKE_BUILD_TYPE=Release
  )
