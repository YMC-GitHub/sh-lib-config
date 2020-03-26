# sh lib config

## desc

curd config for ymc shell code

## feat

- [x] read config from sh arg
- [x] read config from sh config file
- [x] support built-in config file
- [x] support custom config file
- [x] support help msg
- [x] support not built-in config file

## how to use for poduction ?

```sh
# get the code

# run the index file
# ./dist/index.sh

# or import to your sh file
# source /path/to/the/index file

# usage
USAGE_MSG=
USAGE_MSG_PATH=$(path_resolve $THIS_FILE_PATH "../help")
USAGE_MSG_FILE=${USAGE_MSG_PATH}/index.txt

# get args val
GETOPT_ARGS_SHORT_RULE="--options h,d,"
GETOPT_sARGS_LONG_RULE="--long help,debug,not-built-in:,custom-file:"
cache_args "$@"

cache_read_built_in_config

CUSTOM_FILE=$(cache_get_val_by_key "custom-file")
cache_read_custom_config "" "dist" "$CUSTOM_FILE"
cache_ouput_val
```

## how to use for developer ?

```sh
# get the code

# run test
./test/test.index.sh
```

## author

yemiancheng <ymc.github@gmail.com>

## license

MIT
