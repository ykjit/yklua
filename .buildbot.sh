#!/bin/sh

set -e

# First build without the JIT and check the tests still work.
make -j `nproc`
cd tests
../src/lua -e"_U=true" all.lua
cd ..
make clean

# Now test again with the JIT enabled.
#
# First we build ykllvm.
git clone --depth 1 https://github.com/ykjit/ykllvm
cd ykllvm
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=`pwd`/../inst \
    -DLLVM_INSTALL_UTILS=On \
    -DCMAKE_BUILD_TYPE=release \
    -DLLVM_ENABLE_ASSERTIONS=On \
    -DLLVM_ENABLE_PROJECTS="lld;clang" \
	-GNinja \
    ../llvm
cmake --build .
cmake --install .
export PATH=`pwd`/../inst/bin:${PATH}
cd ../..

# Then we build Yk.
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

git clone --depth 1 https://github.com/softdevteam/yk
cd yk && cargo build
cd ..

make -j `nproc` YK_DIR=`pwd`/yk YK_DIR=`pwd`/yk
cd tests
# YKFIXME: The JIT can't yet run the test suite, but the following commented
# commands are what we are aiming at having work.
#
# YKFIXME: The tests are very short-lived and will probably need to be made to
# run longer to allow for JIT compilation to complete.
#
#../src/lua -e"_U=true" all.lua
#YKD_SERIALISE_COMPILATION=1 ../src/lua -e"_U=true" all.lua
