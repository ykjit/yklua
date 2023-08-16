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

git clone --recurse-submodules --depth 1 https://github.com/softdevteam/yk
cd yk
YKB_YKLLVM_BUILD_ARGS="define:CMAKE_C_COMPILER=/usr/bin/clang,define:CMAKE_CXX_COMPILER=/usr/bin/clang++" \
    cargo build
export PATH=`pwd`/bin:${PATH}
cd ..

export YK_BUILD_TYPE=debug
make -j `nproc`

cd tests
# YKFIXME: The JIT can't yet run the test suite, but the following commented
# commands are what we are aiming at having work.
#
# ../src/lua -e"_U=true" all.lua
# YKD_SERIALISE_COMPILATION=1 ../src/lua -e"_U=true" all.lua
#
# (Adding `YKD_SERIALISE_COMPILATION` exercises different threading behaviour
# that could help to shake out more bugs)
#
# Until we can run `all.lua` reliably, we just run the tests that we know to
# run within reasonable time).
LUA=../src/lua
for serialise in 0 1; do
    for test in api bwcoercion closure code constructs events \
        gengc pm tpack tracegc utf8 vararg goto literals cstack; do
        echo "### YKD_SERIALISE_COMPILATION=$serialise $test.lua ###"
        YKD_SERIALISE_COMPILATION=$serialise ${LUA} -e"_U=true" ${test}.lua
    done
done
