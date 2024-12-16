#!/bin/sh
#
# Run third party test suites.

set -eu

# OpenResty LuaJIT Tests.
#
# Selection criteria. We include tests which:
#
#  - Run under regular Lua with exit status zero (success).
#
#  - Don't need external native libraries, like GTK.
#
#  - Don't neeed LuaJIT-specific C extensions (i.e. the ctest and cpptest
#    shared objects).
#
#  - Aren't an FFI test
#
#  - Don't immediately exit if not run under LuaJIT, i.e. the test doesn't do
#    `if not jit or not jit.status or not jit.status() then return end`
#
#  - Are "portable" (i.e. not tests from the "unportable" directory)
#
# This basically amounts to a subset of the `misc` directory. Some of the
# remaining tests are still designed to test something specific about LuaJIT,
# but there's no harm in runing them anyway.
#
# To skip a test, prefix the file name with `-` and add a comment below saying
# why.
ORSTY_MISC_TESTS="ack.lua ack_notail.lua alias_alloc.lua \
    assign_tset_prevnil.lua assign_tset_tmp.lua cat_jit.lua constov.lua \
    coro_traceback.lua coro_yield.lua dse_array.lua dse_field.lua dualnum.lua \
    exit_frame.lua exit_growstack.lua fac.lua fastfib.lua fib.lua for_dir.lua \
    fori_coerce.lua fuse.lua fwd_hrefk_rollback.lua fwd_tnew_tdup.lua \
    fwd_upval.lua gc_rechain.lua hook_line.lua iter-bug.lua jit_record.lua \
    jloop-itern-stack-check-fix.lua kfold.lua loop_unroll.lua math_random.lua \
    meta_arith_jit.lua meta_arith.lua meta_cat.lua meta_comp.lua meta_eq.lua \
    meta_framegap.lua meta_getset.lua meta_nomm.lua meta_pairs.lua \
    meta_tget.lua meta_tset.lua meta_tset_nilget.lua meta_tset_resize.lua \
    meta_tset_str.lua multi_result_call_next.lua nsieve.lua pairs_bug.lua \
    parse_comp.lua parse_hex.lua pcall_jit.lua phi_copyspill.lua \
    phi_rot18.lua phi_rot8.lua phi_rot9.lua phi_rotx.lua recsum.lua \
    recsump.lua recurse_tail.lua select.lua self.lua sink_alloc.lua \
    sink_nosink.lua snap_gcexit.lua snap_top.lua sort.lua stack_gc.lua \
    stackovc.lua stackov.lua stitch.lua strcmp.lua string_char.lua \
    string_op.lua string_sub_opt.lua table_alias.lua table_insert.lua \
    table_remove.lua tak.lua tcall_base.lua tcall_loop.lua tlen_loop.lua \
    tnew_tdup.lua uclo.lua unordered_jit.lua unordered.lua vararg_jit.lua \
    wbarrier_jit.lua wbarrier.lua wbarrier_obar.lua xpcall_jit.lua"

if [ $# -ne 1 ]; then
    echo "usage: $0 <lua-bin>"
    exit 1
fi

lua=$1
failed=""

# Run the OpenResty LuaJIT tests.
for t in $ORSTY_MISC_TESTS; do
    if [ "${t#-}" != "$t" ]; then
        echo "-> Skipping $t"
    else
        echo "-> Running $t"
        if ! $lua luajit2-test-suite/test/misc/$t; then
            echo "FAILED"
            failed="$failed $t"
        fi
    fi
done

# Report any test failures.
if [ ! -z "$failed" ]; then
    echo "The following tests failed:"
    for t in $failed; do
        echo "  $t"
    done
    exit 1
fi
