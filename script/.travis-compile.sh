#!/bin/bash
set -ex

# Setup shortcuts.
ROOT=`pwd`

# Clone nginx read-only git repository.
if [ ! -d "nginx" ]; then
  git clone https://github.com/nginx/nginx.git
fi

# Build nginx + filter module.
cd $ROOT/nginx
if [ ! -f "Makefile" ]; then
  # Pro memoria: --with-debug
  ./auto/configure \
      --prefix=$ROOT/script/test \
      --with-http_v2_module \
      --add-module=$ROOT
fi
make -j 16

# Build brotli CLI.
cd $ROOT/deps/brotli
mkdir -p out
cd out
if [ ! -f "Makefile" ]; then
  cmake ..
fi
make -j 16 brotli

# Restore status-quo.
cd $ROOT
