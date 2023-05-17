#!/bin/bash

set -x # echo on
set -e # exit on error

sudo apt-get -qq update

# Please keep this list sorted.
sudo apt-get -y install \
     build-essential \
     ccache \
     clang \
     clang-tidy \
     cmake \
     curl \
     gfortran \
     libassimp-dev \
     libatlas-base-dev \
     libavcodec-dev \
     libavdevice-dev \
     libavformat-dev \
     libavutil-dev \
     libc++-dev \
     libcrypto++-dev \
     libegl1-mesa-dev \
     libglew-dev \
     libgoogle-glog-dev \
     libgtest-dev \
     libopencv-dev \
     libssl-dev \
     libsuitesparse-dev \
     libswscale-dev \
     libtiff-dev \
     python3-dev \
     python3.8-venv \
     libmtdev-dev \
     libturbojpeg \
     && sudo apt-get clean
