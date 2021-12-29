#!/bin/bash

PREFIX_DIR=$HOME/wonderful/media/ffmpeg_build
BIN_DIR=$HOME/wonderful/media/bin

PATH=$BIN_DIR:$PATH
PKG_CONFIG_PATH=$PREFIX_DIR/lib/pkgconfig:$PKG_CONFIG_PATH

./configure \
	--prefix=$PREFIX_DIR \
	--disable-examples \
	--disable-unit-tests \
	--enable-vp9-highbitdepth \
	--as=yasm \
	--enable-pic

make && make install
