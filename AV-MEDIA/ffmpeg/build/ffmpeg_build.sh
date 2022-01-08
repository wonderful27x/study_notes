#!/bin/bash

PREFIX_DIR=$HOME/wonderful/media/ffmpeg_build
BIN_DIR=$HOME/wonderful/media/bin
INCLUDE_DIR=$HOME/wonderful/media/ffmpeg_build/include
LIB_DIR=$HOME/wonderful/media/ffmpeg_build/lib

PATH=$BIN_DIR:$PATH
export PKG_CONFIG_PATH=$PREFIX_DIR/lib/pkgconfig:$PKG_CONFIG_PATH

CFLAGS="-g -O0 -fPIC"
../configure \
	--prefix=$PREFIX_DIR \
	--bindir=$BIN_DIR \
	--pkg-config-flags="--static" \
	--extra-cflags="-I$INCLUDE_DIR" \
	--extra-ldflags="-L$LIB_DIR" \
	--extra-libs="-lpthread -lm" \
	--enable-gpl \
	--enable-libass \
	--enable-libfdk-aac \
	--enable-libfreetype \
	--enable-libmp3lame \
	--enable-libopus \
	--enable-libvorbis \
	--enable-libvpx \
	--enable-libx264 \
	--enable-libx265 \
	--enable-pic \
	--enable-shared \
	--enable-static \
	--disable-vdpau \
	--disable-vaapi \
	--disable-cuda-llvm \
	--disable-cuvid \
	--enable-nonfree

make && make install
hash -r
