macro(farm_ng_add_library target)
  set(one_value_args NAMESPACE INCLUDE_DIR INCLUDES MAJOR_VERSION MINOR_VERSION PATCH_VERSION)
  set(multi_value_args SOURCES HEADERS)
  cmake_parse_arguments(FARM_NG_ARGS ""
                        "${one_value_args}" "${multi_value_args}" ${ARGN})

  if(NOT DEFINED FARM_NG_ARGS_NAMESPACE)
    message(FATAL_ERROR "\nPlease specify NAMESPACE in farm_ng_add_library(${target})\n")
  endif()

  if(NOT DEFINED FARM_NG_ARGS_INCLUDE_DIR)
    message(FATAL_ERROR "\nPlease specify INCLUDE_DIR in farm_ng_add_library(${target})\n")
  endif()


  if((NOT DEFINED FARM_NG_ARGS_SOURCES) AND (DEFINED FARM_NG_ARGS_HEADERS))
    set(INTERFACE_OR_PUBLIC INTERFACE)
    add_library(${target} INTERFACE)
    #target_sources(${target} INTERFACE ${FARM_NG_ARGS_HEADERS})

  elseif(DEFINED FARM_NG_ARGS_SOURCES)
    add_library(${target} SHARED  ${FARM_NG_ARGS_SOURCES} ${FARM_NG_ARGS_HEADERS})
    set(INTERFACE_OR_PUBLIC PUBLIC)
  endif()

  # if(DEFINED FARM_NG_ARGS_SOURCES)
  #   target_sources(${target} PRIVATE ${FARM_NG_ARGS_SOURCES})
  # endif()
  # if(DEFINED FARM_NG_ARGS_HEADERS)
  #   target_sources(${target} ${INTERFACE_OR_PUBLIC} ${FARM_NG_ARGS_HEADERS})
  # endif()

  #set_target_properties(${target} PROPERTIES PUBLIC_HEADER "${FARM_NG_ARGS_HEADERS}")
  if(NOT "${PROJECT_NAME}" STREQUAL "${FARM_NG_ARGS_NAMESPACE}")
  message(FATAL_ERROR "${PROJECT_NAME} Should match namespace: ${FARM_NG_ARGS_NAMESPACE}")
  endif()
  add_library(${FARM_NG_ARGS_NAMESPACE}::${target} ALIAS ${target})


  if(IS_ABSOLUTE ${FARM_NG_ARGS_INCLUDE_DIR})
    file(RELATIVE_PATH abs_include ${CMAKE_SOURCE_DIR} ${FARM_NG_ARGS_INCLUDE_DIR})
  else()
    file(RELATIVE_PATH abs_include ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/${FARM_NG_ARGS_INCLUDE_DIR})
  endif()

  target_include_directories(${target} ${INTERFACE_OR_PUBLIC}
      "$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/${abs_include}>"
      "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>")

  foreach ( file ${FARM_NG_ARGS_HEADERS} )

    if(IS_ABSOLUTE ${file})
      file(RELATIVE_PATH rel ${CMAKE_SOURCE_DIR}/${abs_include} ${file})
    else()
      file(RELATIVE_PATH rel ${CMAKE_SOURCE_DIR}/${abs_include} ${CMAKE_CURRENT_SOURCE_DIR}/${file})
    endif()
    #message(STATUS "header: ${file}")
    #message(STATUS "header rel: ${rel}")

    get_filename_component( dir ${rel} DIRECTORY )
    # message(STATUS "${FARM_NG_ARGS_INCLUDE_DIR} ${file} ${rel} ${dir}")
    install( FILES ${file}
       DESTINATION include/${dir}
       COMPONENT Devel)
  endforeach()

  if(DEFINED FARM_NG_ARGS_SOURCES)
    string(REPLACE "." ";" VERSION_LIST ${PROJECT_VERSION})
    list(GET VERSION_LIST 0 VERSION_MAJOR)
    list(GET VERSION_LIST 1 VERSION_MINOR)
    list(GET VERSION_LIST 2 VERSION_PATCH)

    set_property(TARGET ${target} PROPERTY VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})
    set_property(TARGET ${target} PROPERTY SOVERSION ${VERSION_MAJOR})
    set_property(TARGET ${target} PROPERTY
      INTERFACE_${target}_MAJOR_VERSION ${VERSION_MAJOR})
    set_property(TARGET ${target} APPEND PROPERTY
      COMPATIBLE_INTERFACE_STRING ${VERSION_MAJOR}
      )
  endif()

  install(TARGETS ${target}
    EXPORT ${PROJECT_NAME}Targets
    LIBRARY DESTINATION lib
    COMPONENT Libs
  )

endmacro()
