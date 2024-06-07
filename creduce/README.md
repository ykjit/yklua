# Creduce with c-vise

See [cvise](https://github.com/marxin/cvise) for more information.

## Setup

Set global environment variables:

```shell
YKLUA_HOME="/path/to/yklua" # local path to https://github.com/ykjit/yklua
YK_BUILD_TYPE=debug
```

Add `yk-config` to the global `PATH`:

```shell
PATH=/path/to/yk/bin:${PATH} # local path to https://github.com/ykjit/yk/blob/master/bin
```

## Run

Build `onelua.c`
```shell
sh ./build_onelua.sh
```

Run creduce with `cvise`:

```shell
cd src
cvise /path/to/interest_script.sh onelua.c
```

See `cvise.example.sh` for an example interest script.

> cvice will reduce the lines of the `onelua.c` file as long as `./cvise.example.sh` executes successfully. It will overwrite the `onelua.c` file in place. Original content can be found in `onelua.c.orig`.
