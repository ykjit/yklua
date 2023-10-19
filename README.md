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
../src/lua -e"_U=true" all.lua # run complete test suite (Currently failing)
```

### Docker

```shell
run_docker_ci_job # local path to https://github.com/softdevteam/buildbot_config/blob/master/bin/run_docker_ci_job

```
## Debugging

Use `LYK_VERBOSE` environment variable to print LYK (lua yk) debug logs:
```shell
LYK_VERBOSE=1 gdb --batch -ex 'r' -ex 'bt' --args ../src/lua all.lua 
LYK_VERBOSE=1 ../src/lua all.lua 
LYK_VERBOSE=1 sh ./test.sh
```

### State of Tests

| Test           | Status  | Issue                                             |
| -------------- | ------- | ------------------------------------------------- |
| api.lua        | Working |                                                   |
| bwcoercion.lua | Working |                                                   |
| closure.lua    | Working |                                                   |
| code.lua       | Working |                                                   |
| events.lua     | Working |                                                   |
| files.lua      | Working |                                                   |
| gengc.lua      | Working |                                                   |
| goto.lua       | Working |                                                   |
| pm.lua         | Working |                                                   |
| tpack.lua      | Working |                                                   |
| tracegc.lua    | Working |                                                   |
| vararg.lua     | Working |                                                   |
| cstack.lua     | Working |                                                   |
| locals.lua     | Working |                                                   |
| coroutine.lua  | Working |                                                   |
| literals.lua   | Working | [issue](https://github.com/ykjit/yklua/issues/57) |
| db.lua         | Failing | [issue](https://github.com/ykjit/yklua/issues/38) |
| attrib.lua     | Failing | [issue](https://github.com/ykjit/yklua/issues/42) |
| bitwise.lua    | Failing | [issue](https://github.com/ykjit/yklua/issues/40) |
| strings.lua    | Failing | [issue](https://github.com/ykjit/yklua/issues/39) |
| calls.lua      | Failing | [issue](https://github.com/ykjit/yklua/issues/43) |
| constructs.lua | Failing | [issue](https://github.com/ykjit/yklua/issues/44) |
| errors.lua     | Failing | [issue](https://github.com/ykjit/yklua/issues/48) |
| math.lua       | Failing | [issue](https://github.com/ykjit/yklua/issues/47) |
| sort.lua       | Failing | [issue](https://github.com/ykjit/yklua/issues/46) |
| nextvar.lua    | Failing | [issue](https://github.com/ykjit/yklua/issues/53) |
| gc.lua         | Failing | [issue](https://github.com/ykjit/yklua/issues/52) |
| utf8.lua       | Failing | [issue](https://github.com/ykjit/yklua/issues/54) |
| big.lua        | Failing | [issue](https://github.com/ykjit/yklua/issues/55) |
| coroutine.lua  | Failing | [issue](https://github.com/ykjit/yklua/issues/58) |
| heavy.lua      | Failing | [issue](https://github.com/ykjit/yklua/issues/59) |
| verybig.lua    | Failing | [issue](https://github.com/ykjit/yklua/issues/56) |
| main.lua       | Failing | [issue](https://github.com/ykjit/yklua/issues/60) |
| all.lua        | Failing | [issue](https://github.com/ykjit/yklua/issues/62) |
