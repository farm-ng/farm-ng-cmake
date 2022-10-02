set(FARM_NG_CMAKE_DIR ${CMAKE_CURRENT_LIST_DIR})
include(CMakePackageConfigHelpers)

macro(farm_ng_module name VERSION)
  # Configure CCache if available
  find_program(CCACHE_FOUND ccache)
  if(CCACHE_FOUND)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
  endif(CCACHE_FOUND)
  set(FARM_NG_MODULE_NAME ${name})
  set(farm_ng_VERSION ${VERSION})

  message(STATUS "${FARM_NG_MODULE_NAME} version: -- ${VERSION} --")
  string(REPLACE "." ";" VERSION_LIST ${VERSION})
  list(GET VERSION_LIST 0 farm_ng_VERSION_MAJOR)
  list(GET VERSION_LIST 1 farm_ng_VERSION_MINOR)
  list(GET VERSION_LIST 2 farm_ng_VERSION_PATCH)

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
