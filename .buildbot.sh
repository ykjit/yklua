#!/bin/sh

set -e

make -j `nproc`

# https://www.lua.org/tests/
cd tests
../src/lua -e"_U=true" all.lua
