#!/bin/sh

set -e

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
#
# By default, when we run all.lua test suite, it runs underlying tests with a non-yk lua interpreter.

LUA=../src/lua

NON_SERIALISED="api bwcoercion closure code events gengc pm tpack tracegc vararg goto cstack locals"

# Non-serialised compilation tests
# YKFIXME: The following tests are known to work only with non-serialised JIT
for test in ${NON_SERIALISED}; do
    YKD_SERIALISE_COMPILATION=0 ${LUA} -e"_U=true" ${test}.lua
done

# YKFIXME: The following tests are known to work with serialised JIT
serialised="${NON_SERIALISED} sort"
for test in $serialised; do
    YKD_SERIALISE_COMPILATION=1 ${LUA} -e"_U=true" ${test}.lua
done
