#!/bin/sh
#
# This script tries to run as many individual tests as possible, reporting
# those which succeed for both YKD_SERIALISE_COMPILATION=0 and
# YKD_SERIALISE_COMPILATION=1.
#
# You can use the output to adjust which tests run in `.buildbot.sh`.
#
# As soon as `all.lua` runs, we can just run that and delete this script.
#
# Note that many tests require setup code in `all.lua` to generate some files
# for the tests to run properly. So some tests will be failing due to that.

set -e

if [ $(uname) != "Linux" ]; then
    # Due to descrepancies of the exit status of `timeout`.
    echo "this script only runs on linux"
    exit 1
fi

SECS=120
LUA=src/lua

OK=""
FAIL=""
for tst in tests/*.lua; do
    btst=$(basename ${tst})
    echo -n "> $tst(YKD_SERIALISE_COMPILATION=0)..."
    exstatus=0
    YKD_SERIALISE_COMPILATION=0 timeout -s9 ${SECS}s ${LUA} ${tst} \
        >/dev/null 2>&1 || exstatus=$?

    if [ ${exstatus} -eq 0 ]; then
        # Try test again with JIT compilation on the main thread. Only if this
        # also succeeds do we classify the test as "OK".
        echo "OK"
        echo -n "> $tst(YKD_SERIALISE_COMPILATION=1)..."
        exstatus=0
        YKD_SERIALISE_COMPILATION=1 timeout -s9 ${SECS}s ${LUA} ${tst} \
            >/dev/null 2>&1 || exstatus=$?
        if [ ${exstatus} -eq 0 ]; then
            echo "OK"
            OK="${OK} ${btst}"
        else
            if [ ${exstatus} -eq 137 ]; then
                echo "TIMEOUT"
            else
                echo "FAIL"
            fi
            FAIL="${FAIL} ${btst}"
        fi
    else
        if [ ${exstatus} -eq 137 ]; then
            echo "TIMEOUT"
        else
            echo "FAIL"
        fi
        FAIL="${FAIL} ${btst}"
    fi
done

echo "\n---"
echo "OK: ${OK}"
echo "FAIL: ${FAIL}"
