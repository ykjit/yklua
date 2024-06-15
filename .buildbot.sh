#!/bin/sh

set -e

# First build without the JIT and check the tests still work.
make -j `nproc`
cd tests
../src/lua -e"_U=true" all.lua
cd ..
make clean

# Now test again with the JIT enabled.
export CARGO_HOME="`pwd`/.cargo"
export RUSTUP_HOME="`pwd`/.rustup"
export RUSTUP_INIT_SKIP_PATH_CHECK="yes"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh
sh rustup.sh --default-host x86_64-unknown-linux-gnu \
    --default-toolchain nightly \
    --no-modify-path \
    --profile minimal \
    -y
export PATH=`pwd`/.cargo/bin/:$PATH

git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/ykjit/yk
cd yk
echo "yk commit: $(git show -s --format=%H)"

cd ykllvm
ykllvm_hash=$(git rev-parse HEAD)
if [ -f /opt/ykllvm_cache/ykllvm-release-with-assertions-"${ykllvm_hash}".tgz ]; then
    mkdir inst
    cd inst
    tar xfz /opt/ykllvm_cache/ykllvm-release-with-assertions-"${ykllvm_hash}".tgz
    cd ..
    # Minimally check that we can at least run `clang --version`: if we can't,
    # we assume the cached binary is too old (e.g. linking against old shared
    # objects) and that we should build our own version.
    if inst/bin/clang --version > /dev/null; then
        export YKB_YKLLVM_BIN_DIR="$(pwd)/inst/bin"
    else
        echo "Warning: cached ykllvm not runnable; building from scratch" > /dev/stderr
        rm -rf inst
    fi
fi
cd ..

YKB_YKLLVM_BUILD_ARGS="define:CMAKE_C_COMPILER=/usr/bin/clang,define:CMAKE_CXX_COMPILER=/usr/bin/clang++" \
    cargo build
export PATH=`pwd`/bin:${PATH}
cd ..

YK_BUILD_TYPE=debug make -j `nproc`

# Run the test suite
cd tests && YKD_SERIALISE_COMPILATION=1 ../src/lua -e"_U=true" all.lua
