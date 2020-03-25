#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source "${THIS_FILE_PATH}/sh-lib-path-resolve.sh"
PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")

# include some lib
#source "${PROJECT_PATH}/test/sh-lib-test.sh"
#2 include lib cache
source "${PROJECT_PATH}/dist/sh-lib-cache.sh"

# use hime
#2 set
cache_set_val "name" "k8s-worker-4"
#2 get
cache_get_val "name"
#2 u
cache_set_val "name" "k8s-worker-5"
#2 r
cache_get_val "name"
#2 u
cache_set_val "name" "k8s-worker-5"
#2 d
#cache_set_val "name" ""
#cache_get_val "name"
cache_set_val "name" "null"
cache_get_val "name"

#source "${PROJECT_PATH}/dist/sh-lib-cache.sh"
#cache_get_val "name"

: <<NOTE
test 'cache_set_val "name" "null"' ""
test 'cache_get_val "name"' "null"
NOTE
## file usage
#./test/test.lib.cache.sh
