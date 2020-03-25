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

# 参数帮助信息
USAGE_MSG=
USAGE_MSG_PATH="$HELP_DIR"
USAGE_MSG_FILE="${HELP_DIR}/write-helps.txt"
USAGE_MSG=$(get_help_msg "$USAGE_MSG" "$USAGE_MSG_FILE")
# 缓存参数取值
GETOPT_ARGS_SHORT_RULE="--options h,d,"
GETOPT_ARGS_LONG_RULE="--long help,debug,project-path:,file-list:"
cache_args "$@"

# 一些配置信息
FILE_PATH=src
FILE_PATH=$(path_resolve $PROJECT_PATH $FILE_PATH)
FILE_NAME=write-docs
# 创建相关目录
mkdir -p $FILE_PATH

function get_part() {
  local FLAG_SYMBOL=
  local FILE_PATH=
  local BeginFlag=
  local EndFlag=
  local FILE=
  local PART_CONTENT=

  FLAG_SYMBOL=desc
  FILE_PATH="$SRC_DIR"
  if [[ -n "$1" ]]; then
    FLAG_SYMBOL=$1
  fi
  if [[ -n "$2" ]]; then
    FILE_PATH=$(path_resolve $PROJECT_PATH $2)
  fi
  # the begining flag of the section
  BeginFlag="<$FLAG_SYMBOL>"
  # the ending flag of the section
  EndFlag="<$FLAG_SYMBOL/>"

  declare -i Bnum
  declare -i Enum
  declare -i nums
  FILE="$FILE_PATH/$FILE_NAME.help.txt" #$1
  # line number of the beginning flag
  Bnum=$(grep -n "$BeginFlag" $FILE | cut -d: -f1)
  # line number of the ending flag
  Enum=$(grep -n "$EndFlag" $FILE | cut -d: -f1)
  # lines between the begining and ending flag
  nums=$(($Enum - $Bnum))
  #echo $Bnum,$Enum,$nums
  # output the result into stdout
  PART_CONTENT=$(grep -A $nums "$BeginFlag" $FILE | sed "s#<$FLAG_SYMBOL>#$FLAG_SYMBOL:#" | sed "s#<$FLAG_SYMBOL/>##")
  echo "$PART_CONTENT"
}

function write_doc() {

  local FILE_NAME=
  local FILE_PATH=
  local part_desc=
  local part_args=
  local part_how_to_run=
  local part_demo_with_args=
  local part_how_to_get_help=
  local file=
  local src=
  local des=

  if [[ -n "$1" ]]; then
    FILE_NAME=$1
  fi
  FILE_PATH="$SRC_DIR"
  if [[ -n "$2" ]]; then
    FILE_PATH=$(path_resolve $PROJECT_PATH $2)
  fi

  #file="${FILE_PATH}/${FILE_NAME}.help.txt"
  file="${FILE_PATH}/${FILE_NAME}.txt"
  echo "write docs $file"
  part_desc=$(get_part desc)
  part_args=$(get_part args)
  part_how_to_run=$(get_part how-to-run)
  part_demo_with_args=$(get_part demo-with-args)
  part_how_to_get_help=$(get_part how-to-get-help)
  cat >"$file" <<eof
$part_desc
$part_args
$part_how_to_run
$part_demo_with_args
$part_how_to_get_help
eof
  #src="$file"
  #des="$HELP_PATH/$FILE_NAME.txt"
  #echo "write docs $des"
  #cp -f "$src" "$des"
}

function main() {
  local list=
  local arr=
  local val=

  list=$(cache_get_arg_val "file-list")
  if [ -n "$list" ]; then
    list=$(cat $(path_resolve $PROJECT_PATH $list))
  fi
  #echo "$list"
  # multi line str to arr
  arr=(${list//,/ })
  for val in ${arr[@]}; do
    write_doc "$val" "$HELP_DIR"
  done
}
main
# 追踪文档
: <<delete-git_add-file
for val in ${FILE_TO_WRITE_LIST_ARR[@]}; do
  echo "git add help docs help/$val.txt"
  git add "help/$val.txt"
done
delete-git_add-file

# file usage
# bash ./tool/write-helps.sh
