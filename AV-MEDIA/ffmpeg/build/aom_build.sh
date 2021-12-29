#!/bin/bash

PREFIX_DIR=$HOME/wonderful/media/ffmpeg_build
BIN_DIR=$HOME/wonderful/media/bin

PATH=$BIN_DIR:$PATH
PKG_CONFIG_PATH=$PREFIX_DIR/lib/pkgconfig:$PKG_CONFIG_PATH

cmake -G "Unix Makefiles" \
      -DCMAKE_INSTALL_PREFIX=$PREFIX_DIR \
      -DENABLE_SHARED=off \
      -DENABLE_NASM=on \
      ..

make && make install

