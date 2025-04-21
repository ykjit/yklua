# Yk-enabled Lua

This is the reference Lua interpreter with the Yk JIT retrofitted.

This is experimental!


## Build

GNU make is required.

Run:
```shell
export PATH=/path/to/yk/bin:${PATH} # local path to https://github.com/ykjit/yk/blob/master/bin/yk-config (yk needs to be compiled)
export YK_BUILD_TYPE=<debug|release>
make -j "$(nproc)"
```

To build with debug string support for both `HotLocation`s and per Lua
`Instruction` in a trace, define the `YKLUA_DEBUG_STRS` preprocessor macro:

```shell
make -j "$(nproc)" MYCFLAGS=-DYKLUA_DEBUG_STRS
```

With an unspecified value, or a value of `1`, `YKLUA_DEBUG_STRS` will put full path
names into the debug output. To output only leaf names, set `-DYKLUA_DEBUG_STRS=2`.


## Run

```shell
./src/lua -e "print('Hello World')" # execute program passed in as string
./src/lua ./tests/utf8.lua # execute lua program file
./src/luac ./tests/utf8.lua -o ./utf8.out # translates lua programs into Lua bytecode
```

## Test

> Make sure to build the project first.

```shell
cd tests # navigate to tests directory
../src/lua -e"_U=true" db.lua # run single file
../src/lua -e"_U=true" all.lua # run complete test suite (Currently failing for non-serialised compilation)
```
