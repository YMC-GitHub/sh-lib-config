#!/bin/sh
THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source "$THIS_FILE_PATH/sh-lib-path-resolve.sh"
PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
#DIST_DIR=$(path_resolve "$PROJECT_PATH" "dist)
source "${PROJECT_PATH}/dist/config.project.dir.map.sh"
source "${PROJECT_PATH}/dist/sh-lib-output-msg.sh"
source "${PROJECT_PATH}/dist/sh-lib-help-msg.sh"
source "${DIST_DIR}/parse-passed-arg.sh"

# 帮助信息
USAGE_MSG=$(
  cat <<EOF
desc:
  make project dir construtor
args:
  --project-path optional,set the project path
  -d,--debug optional,set the debug mode
  -h,--help optional,get the cmd help
how-to-run:
  run as shell args
    bash ./make-project.sh
  run as runable application
    ./make-project.sh --project-path eth0
demo-with-args:
  without-args
    ok:./make-project.sh
  passed arg with necessary value
    ok:./make-project.sh --project-path eth0
    ok:./make-project.sh --project-path=eth0
  passed arg with optional value
  passed arg without value
  basic-usage:
    set the project path
      with relative path ,it relative to the project path
        ok:./make-project.sh --project-path ../hell-get-config
      with absolute path
        ok:./make-project.sh --project-path /d/code-store/Shell/shell-get-config
how-to-get-help:
  ok:./make-project.sh --help
  ok:./make-project.sh -h
  ok:./make-project.sh --debug
EOF
)
USAGE_MSG_PATH="$HELP_DIR"
USAGE_MSG_FILE="${HELP_DIR}/make-project.txt"
USAGE_MSG=$(get_help_msg "$USAGE_MSG" "$USAGE_MSG_FILE")

#缓存参数取值
GETOPT_ARGS_SHORT_RULE="--options h,d,"
GETOPT_ARGS_LONG_RULE="--long help,debug,project-path:"
cache_args "$@"

#执行脚本目录
RUN_SCRIPT_PATH=$(pwd)
#echo "the running scripts path is $RUN_SCRIPT_PATH"
#当前脚本目录
#echo "the script file 's path is $THIS_FILE_PATH"
#脚本工程目录
BUILT_IN_PROJECT_PATH=$(path_resolve $THIS_FILE_PATH "../")
#echo "the built in path is $BUILT_IN_PROJECT_PATH"
#自定工程目录
val=$(cache_get_arg_val "project-path")
CUSTOM_PROJECT_PATH=$(path_resolve "$BUILT_IN_PROJECT_PATH" "$val")
#echo "the custom path is $CUSTOM_PROJECT_PATH"s

if [ -n "$val" ]; then
  #echo "uses custom path as project path"
  PROJECT_PATH="$CUSTOM_PROJECT_PATH"
else
  #echo "uses running scripts path as project path"
  PROJECT_PATH="$RUN_SCRIPT_PATH"
fi

function get_dir_list() {
  local path=
  local list=

  path="$PROJECT_PATH"
  if [ -n "$1" ]; then
    path="$1"
  fi

  HELP_DIR=$path/help
  SRC_DIR=$path/src
  TEST_DIR=$path/test
  DIST_DIR=$path/dist
  DOCS_DIR=$path/docs
  TOOL_DIR=$path/tool
  DEBUG_DIR=$path/debug
  list=$(
    cat <<EOF
$HELP_DIR
$SRC_DIR
$TEST_DIR
$DIST_DIR
$DOCS_DIR
$TOOL_DIR
$DEBUG_DIR
EOF
  )
  echo "$list"
}
function make_project_dir() {
  local arr=
  local list=
  local val=

  list=$(
    cat <<EOF
$HELP_DIR
$SRC_DIR
$TEST_DIR
$DIST_DIR
$DOCS_DIR
$TOOL_DIR
$DEBUG_DIR
EOF
  )
  if [ -n "$1" ]; then
    list="$1"
  fi
  #delete sh line comment
  list=$(echo "$list" | sed "s/^ *#.*//g")
  #delete space line
  list=$(echo "$list" | sed "/^$/d")
  # str to arr
  arr=(${list//,/ })
  # make some dir
  for i in ${!arr[@]}; do
    val=${arr[$i]}
    mkdir -p "$val"
  done
}

echo "create project dir for $PROJECT_PATH"
list=$(get_dir_list "$PROJECT_PATH")
make_project_dir "$list"

## file usage
# ./tool/make-project.sh
#/d/code-store/Shell/shell-get-config/tool/make-project.sh
