#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source "${THIS_FILE_PATH}/sh-lib-path-resolve.sh"
PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")

#source "${PROJECT_PATH}/dist/parse-passed-arg.sh"
#source "${PROJECT_PATH}/dist/read-from-file.sh"
source "${PROJECT_PATH}/dist/index.sh"
cache_read_built_in_config
cache_ouput_val
cache_read_custom_config

cache_get_val_by_key "k8s-worker-4"
cache_get_val_by_key "custom-file"
cache_get_val_by_key "k8s-worker-7"
## file usage
#./test/test.index.sh --custom-file a-config-file-2.txt
