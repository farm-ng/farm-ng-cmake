#!/bin/bash

set -x # echo on
set -e # exit on error

# MacOS CI wasn't liking backslash line wrapping, so listed here on one line.
brew install --verbose assimp catch2 ccache ffmpeg glew glog libjpeg libpng libtiff lz4 opencv openexr openssl pre-commit zstd
