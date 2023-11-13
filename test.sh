#!/bin/sh

set -e

cd tests

# YKFIXME: The YK JIT can't yet run the test suite with non-serialised compilation (YKD_SERIALISE_COMPILATION=0).
# YKD_SERIALISE_COMPILATION=1 ../src/lua -e"_U=true" all.lua

# Running tests with a serialised compilation
YKD_SERIALISE_COMPILATION=1 ../src/lua -e"_U=true" all.lua
