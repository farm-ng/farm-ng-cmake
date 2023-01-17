#!/bin/bash -ex
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
python3 -m venv venv
. venv/bin/activate
pip install -U pip
pip install -U wheel
pip install -U cmake ninja

FARM_NG_CMAKE_PATH="${1:-.}"

mkdir -p build.venv
cd build.venv
cmake \
    -DFARM_NG_DEV_BUILD=On \
    -Dfarm_ng_INSTALL_PREFIX=$DIR/venv \
    -G Ninja \
    $DIR/$FARM_NG_CMAKE_PATH

ninja -v
