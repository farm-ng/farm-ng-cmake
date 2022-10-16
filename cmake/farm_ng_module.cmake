set(FARM_NG_CMAKE_DIR ${CMAKE_CURRENT_LIST_DIR})
option(FARM_NG_INSTALL_MODULES "Install farm-ng modules, off by default which makes them in source for development" Off)

include(CMakePackageConfigHelpers)

macro(farm_ng_module)
  # Configure CCache if available
  find_program(CCACHE_FOUND ccache)
  if(CCACHE_FOUND)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
  endif(CCACHE_FOUND)


  include(CMakeToolsHelpers OPTIONAL)

  set(PKG_CONFIG_USE_CMAKE_PREFIX_PATH ON)
  set(BUILD_SHARED_LIBS ON)
  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
  if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror -Wall -Wextra -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function")
  elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror -Wall -Wextra -Wno-unused-parameter -Wno-unused-but-set-variable -Wno-unused-variable -Wno-unused-function -Wno-maybe-uninitialized")
  endif()

  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
endmacro()


macro(farm_ng_export_module)
  set(one_value_args NAME)
  set(multi_value_args REQUIRED_DEPS OPTIONAL_DEPS)
  cmake_parse_arguments(FARM_NG_EXPORT_MODULE ""
                        "${one_value_args}" "${multi_value_args}" ${ARGN})


  write_basic_package_version_file(
    ${FARM_NG_EXPORT_MODULE_NAME}ConfigVersion.cmake
    VERSION ${PACKAGE_VERSION}
    COMPATIBILITY AnyNewerVersion
    )



  # https://cmake.org/cmake/help/latest/guide/importing-exporting/index.html#exporting-targets-from-the-build-tree
  export(EXPORT ${FARM_NG_EXPORT_MODULE_NAME}Targets
    FILE "${CMAKE_CURRENT_BINARY_DIR}/${FARM_NG_EXPORT_MODULE_NAME}Targets.cmake"
    NAMESPACE ${FARM_NG_EXPORT_MODULE_NAME}::
    )
  install(EXPORT  ${FARM_NG_EXPORT_MODULE_NAME}Targets
    FILE ${FARM_NG_EXPORT_MODULE_NAME}Targets.cmake
    NAMESPACE ${FARM_NG_EXPORT_MODULE_NAME}::
    DESTINATION share/${FARM_NG_EXPORT_MODULE_NAME}/cmake
    )

  configure_file(${FARM_NG_CMAKE_DIR}/farm_ng_moduleConfig.cmake.in ${FARM_NG_EXPORT_MODULE_NAME}Config.cmake @ONLY)
  install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/${FARM_NG_EXPORT_MODULE_NAME}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/${FARM_NG_EXPORT_MODULE_NAME}ConfigVersion.cmake"
    DESTINATION
    share/${FARM_NG_EXPORT_MODULE_NAME}/cmake)

endmacro()

macro(farm_ng_external_module NAME)
  set(one_value_args SOURCE_DIR)
  set(multi_value_args DEPENDS MODULE_DEPENDS CMAKE_ARGS)
  cmake_parse_arguments(FARM_NG_ARGS ""
                        "${one_value_args}" "${multi_value_args}" ${ARGN})

  set(_BINARY_DIR                        ${CMAKE_CURRENT_BINARY_DIR}/${NAME}-build)
  set(dep_dir_flags)
  if(FARM_NG_INSTALL_MODULES)
    set(INSTALL_COMMAND_OPTION cmake --build . --target install)
  else()
    set(INSTALL_COMMAND_OPTION cmake -E echo "Skipping install step.")
    foreach(dep ${FARM_NG_ARGS_MODULE_DEPENDS})
        set(dep_dir_flags "${dep_dir_flags} -D${dep}_DIR=${CMAKE_CURRENT_BINARY_DIR}/${dep}-build")
    endforeach()
  endif()



    ExternalProject_Add(${NAME}
        DEPENDS ${FARM_NG_ARGS_DEPENDS} ${FARM_NG_ARGS_MODULE_DEPENDS}
        PREFIX ${farm_ng_EXT_PREFIX}
        SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${FARM_NG_ARGS_SOURCE_DIR}
        BINARY_DIR ${_BINARY_DIR}
        CMAKE_ARGS
        ${farm_ng_DEFAULT_ARGS}
        ${FARM_NG_ARGS_CMAKE_ARGS}
        -DBUILD_FARM_NG_PROTOS=ON
        -Dfarm_ng_cmake_DIR=${farm_ng_cmake_DIR}
        ${dep_dir_flags}
        TEST_BEFORE_INSTALL OFF
        INSTALL_COMMAND "${INSTALL_COMMAND_OPTION}"
    )
endmacro()