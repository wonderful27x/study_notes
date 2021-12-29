#!/bin/bash

PREFIX_DIR=$HOME/wonderful/media/ffmpeg_build
BIN_DIR=$HOME/wonderful/media/bin

PATH=$BIN_DIR:$PATH
PKG_CONFIG_PATH=$PREFIX_DIR/lib/pkgconfig:$PKG_CONFIG_PATH

./autogen.sh
./configure \
	--prefix=$PREFIX_DIR \
	--bindir=$BIN_DIR

make && make install
