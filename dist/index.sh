#!/bin/sh
THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source "${THIS_FILE_PATH}/parse-passed-arg.sh"
source "${THIS_FILE_PATH}/read-from-file.sh"

: <<simple-usage
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
simple-usage
## file usage
# ./dist/index.sh
#./dist/index.sh --custom-file a-config-file-2.txt
#./dist/index.sh --custom-file a-config-file-2.txt --not-built-in true
