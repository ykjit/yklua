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

LUA=../src/lua

for serialise in 0 1; do
    for test in api bwcoercion closure code events \
                gengc pm tpack tracegc vararg goto cstack locals coroutine; do
        echo "### YKD_SERIALISE_COMPILATION=$serialise $test.lua ###"
        YKD_SERIALISE_COMPILATION=$serialise ${LUA} ${test}.lua
    done
done
