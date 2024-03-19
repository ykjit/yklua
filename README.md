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

### Compilation Flags

`LYK_DEBUG` - conditionally compiles debugging functionality for YK integration.

### Environment variables

`LYK_VERBOSE` - enables verbose logs for YK integration. Used for tracking location allocation and function prototypes in the Lua runtime.

> Will only work if yklua is compiled with `LYK_DEBUG` flag.

Example:
```shell
LYK_VERBOSE=1 ./src/lua ./fibo.lua
[LYK] yk_new_proto 0x137ee60
[LYK] yk_location_new. 0x137ee60->yklocs[12]=0x1378a60
[LYK] yk_location_drop. 0x137ee60->yklocs[12]=0x1378a60
```

## Run

```shell
./src/lua -e "print('Hello World')" # execute program passed in as string
./src/lua ./tests/utf8.lua # execute lua program file
./src/luac ./tests/utf8.lua -o ./utf8.out # translates lua programs into Lua bytecode
```

## Test

> Make sure to build the project first.

### CI tests

```shell
sh ./test.sh
```

### Other ways of running tests

```shell
cd tests # navigate to tests directory
../src/lua -e"_U=true" db.lua # run single file
../src/lua -e"_U=true" all.lua # run complete test suite (Currently failing for non-serialised compilation)
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

| Test           | Status (Paralel)  | Status (Serialised)| Issue                                             |
| -------------- | ----------------- | -------------------| ------------------------------------------------- |
| api.lua        | Working           | Working            |                                                   |
| bwcoercion.lua | Working           | Working            |                                                   |
| closure.lua    | Working           | Working            |                                                   |
| code.lua       | Working           | Working            |                                                   |
| events.lua     | Working           | Working            |                                                   |
| gengc.lua      | Working           | Working            |                                                   |
| goto.lua       | Working           | Working            |                                                   |
| pm.lua         | Working           | Working            |                                                   |
| tpack.lua      | Working           | Working            |                                                   |
| tracegc.lua    | Working           | Working            |                                                   |
| vararg.lua     | Working           | Working            |                                                   |
| cstack.lua     | Working           | Working            |                                                   |
| locals.lua     | Working           | Working            |                                                   |
| files.lua      | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/74) |
| literals.lua   | Working           | Working            | [issue](https://github.com/ykjit/yklua/issues/57) |
| db.lua         | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/38) |
| attrib.lua     | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/42) |
| bitwise.lua    | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/40) |
| strings.lua    | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/39) |
| calls.lua      | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/43) |
| constructs.lua | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/44) |
| errors.lua     | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/48) |
| math.lua       | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/47) |
| sort.lua       | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/46) |
| nextvar.lua    | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/53) |
| gc.lua         | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/52) |
| utf8.lua       | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/54) |
| big.lua        | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/55) |
| coroutine.lua  | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/58) |
| heavy.lua      | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/59) |
| verybig.lua    | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/56) |
| main.lua       | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/60) |
| all.lua        | Failing           | Working            | [issue](https://github.com/ykjit/yklua/issues/62) |
