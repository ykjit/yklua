#!/bin/sh

set -eu

if ! command -v cvise 2>&1 ; then
    echo "Binary 'cvise' is not accessible in the system or not in the PATH."
    echo "See installation instructions: https://github.com/marxin/cvise."
    exit 1
fi

if [ -d "./src" ]; then
    rm -fr "./src"
fi

cp -r "../src" "./src"
cp "Makefile" "./src/Makefile"
cp "./one.c" "./src/one.c"

cd "./src"

make onelua.c
