option(BUILD_FARM_NG_PROTOS "Build the farm-ng protobufs" ON)
if(${BUILD_FARM_NG_PROTOS})
  # TODO: make less brittle.
  if(EXISTS "/opt/homebrew/Cellar/openssl@3/3.0.7")
    set(OPENSSL_ROOT_DIR "/opt/homebrew/Cellar/openssl@3/3.0.7")
  endif()

  find_package(OpenSSL REQUIRED)
  find_package(Protobuf REQUIRED)
  find_package(gRPC QUIET)
  if(NOT gRPC_FOUND)
    # fall back to pkg-config
    find_package(PkgConfig REQUIRED)
    pkg_search_module(GRPC REQUIRED IMPORTED_TARGET grpc)
    pkg_search_module(GRPCPP REQUIRED IMPORTED_TARGET grpc++)

    add_library(gRPC::grpc ALIAS PkgConfig::GRPC)
    add_library(gRPC::grpc++ ALIAS PkgConfig::GRPCPP)
  endif()
endif()

macro(farm_ng_add_protobufs target)
  if(${BUILD_FARM_NG_PROTOS})
  set(multi_value_args NAMESPACE PROTO_FILES DEPENDENCIES INCLUDE_DIRS)

  cmake_parse_arguments(FARM_NG_ADD_PROTOBUFS "" "" "${multi_value_args}" ${ARGN})
  set(${target}_PROTOBUF_IMPORT_DIRS ${CMAKE_CURRENT_SOURCE_DIR} CACHE STRING "Path to this project's protobuf sources")

  foreach(dir ${FARM_NG_ADD_PROTOBUFS_INCLUDE_DIRS})
    list(APPEND DEP_PROTO_INCLUDES  -I ${dir})
  endforeach()


  if(NOT DEFINED FARM_NG_ADD_PROTOBUFS_NAMESPACE)
    message(FATAL_ERROR "\nPlease specify NAMESPACE in farm_ng_add_protobufs(${target})\n")
  endif()

  set(_proto_output_dir_cpp ${CMAKE_CURRENT_BINARY_DIR})

  find_program( GRPC_CPP_PLUGIN
    NAMES grpc_cpp_plugin
    PATHS
      /opt/homebrew/bin
      /usr/bin
  )


  set(_cpp_out_headers)
  # Note we populate these files here so we can install them.
  foreach (_proto_path ${FARM_NG_ADD_PROTOBUFS_PROTO_FILES})
    SET(_full_proto_path ${CMAKE_CURRENT_SOURCE_DIR}/${_proto_path})
    get_filename_component(_file_we ${_proto_path} NAME_WE)
    get_filename_component(_file_dir ${_proto_path} DIRECTORY)


    SET(_cpp_out_prefix ${_proto_output_dir_cpp}/${_file_dir}/${_file_we})
    list(APPEND _cpp_out_headers ${_cpp_out_prefix}.pb.h ${_cpp_out_prefix}.grpc.pb.h)

    get_filename_component( dir ${_proto_path} DIRECTORY )
    install( FILES ${_proto_path}
       DESTINATION include/${dir}
       COMPONENT Devel)
  endforeach()

  farm_ng_add_library(${target}
    NAMESPACE ${FARM_NG_ADD_PROTOBUFS_NAMESPACE}
    INCLUDE_DIR ${_proto_output_dir_cpp}
    HEADERS
    ${_cpp_out_headers}
    SOURCES
    ${FARM_NG_ADD_PROTOBUFS_PROTO_FILES}
    )

  target_link_libraries(${target}
    PUBLIC protobuf::libprotobuf gRPC::grpc gRPC::grpc++
    ${FARM_NG_ADD_PROTOBUFS_DEPENDENCIES})

  protobuf_generate(
    TARGET ${target}
    LANGUAGE cpp
    GENERATE_EXTENSIONS .pb.h .pb.cc
    IMPORT_DIRS ${FARM_NG_ADD_PROTOBUFS_INCLUDE_DIRS})

  protobuf_generate(
    TARGET ${target}
    LANGUAGE grpc_cpp
    GENERATE_EXTENSIONS .grpc.pb.h .grpc.pb.cc
    PLUGIN "protoc-gen-grpc_cpp=${GRPC_CPP_PLUGIN}"
    IMPORT_DIRS ${FARM_NG_ADD_PROTOBUFS_INCLUDE_DIRS})

  set_target_properties(${target}
    PROPERTIES CXX_CLANG_TIDY "")

    # Create custom target for building all protobus
    if (NOT TARGET protobuf_all)
      add_custom_target(protobuf_all)
    endif()
    add_dependencies(protobuf_all ${target})
  endif()
endmacro()
