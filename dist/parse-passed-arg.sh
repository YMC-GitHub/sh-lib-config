THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source "$THIS_FILE_PATH/sh-lib-path-resolve.sh"
PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
source "${PROJECT_PATH}/dist/config.project.dir.map.sh"
source "${DIST_DIR}/sh-lib-cache.sh"
source "${DIST_DIR}/sh-lib-help-msg.sh"

USAGE_MSG=
USAGE_MSG_PATH=$(path_resolve $THIS_FILE_PATH "../help")
USAGE_MSG_FILE=${USAGE_MSG_PATH}/clone-one.txt
GETOPT_ARGS_SHORT_RULE="--options h,d,"
GETOPT_ARGS_LONG_RULE="--long help,debug,old-vm-name:,new-vm-name:,path-delimeter-char:"

# 解析脚本参数
function cache_args() {
  # 脚本帮助信息
  USAGE_MSG=$(get_help_msg "$USAGE_MSG" "$USAGE_MSG_FILE")
  #2参数规则内容
  #GETOPT_ARGS_SHORT_RULE="--options h,d,"
  #GETOPT_ARGS_LONG_RULE="--long help,debug,old-vm-name:,new-vm-name:,path-delimeter-char:"
  #2设置参数规则
  #2重排参数顺序
  GETOPT_ARGS=$(
    getopt $GETOPT_ARGS_SHORT_RULE \
      $GETOPT_ARGS_LONG_RULE -- "$@"
  )
  #2设置动态参数
  eval set -- "$GETOPT_ARGS"
  #2缓存所传参数
  while [ -n "$1" ]; do
    if [[ "$1" = "--help" || "$1" = "-h" ]]; then
      echo "$USAGE_MSG"
      exit 1
    fi
    if [[ "$1" = "--debug" || "$1" = "-d" ]]; then
      cache_set_arg_val "IS_DEBUG_MODE" "true"
      shift 2
    elif [[ "$1" = "--" ]]; then
      break
    else
      key="$1"
      # delete ^--
      key=$(echo "$key" | sed "s/^--//g")
      # replace - to _
      #key=$(echo "$key" | sed "s/-/_/g")
      # from a to A
      #key=$(echo "$key" | tr 'a-z' 'A-Z')
      cache_set_arg_val "$key" "$2"
      shift 2
    fi
    #echo "$1"
  done
}
## function usage
: <<NOTE
GETOPT_ARGS_SHORT_RULE="--options h,d,"
GETOPT_sARGS_LONG_RULE="--long help,debug,old-vm-name:,new-vm-name:,path-delimeter-char:"
cache_args "$@"
cache_ouput_val
#cache_get_val_by_key "old-vm-name"
cache_get_arg_val "old-vm-name"
NOTE
# file usage
# ./dist/parse-passed-arg.sh --custom-file a-config-file-2.txt
# ./dist/parse-passed-arg.sh  --custom-file a-config-file-2.txt --old-vm-name "xx"
# ./dist/parse-passed-arg.sh  --help
