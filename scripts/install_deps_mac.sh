#!/bin/bash

set -x # echo on
set -e # exit on error

brew install --verbose \
    assimp \
    # boost \
    catch2 \
    ccache \
    # ceres-solver \
    ffmpeg \
    glew \
    glog \
    # grpc \
    libjpeg \
    libpng \
    libtiff \
    lz4 \
    opencv \
    openexr \
    openssl \
    pre-commit \
    # protobuf \
    zstd
