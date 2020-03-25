#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source "$THIS_FILE_PATH/sh-lib-path-resolve.sh"
PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
source "${PROJECT_PATH}/dist/config.project.dir.map.sh"
source "${DIST_DIR}/sh-lib-cache.sh"
source "${DIST_DIR}/sh-lib-help-msg.sh"
source "${DIST_DIR}/sh-lib-output-msg.sh"

FILE_PATH=$THIS_FILE_PATH       #the default is relative tp the peoject dir
BUILT_IN_FILE=a-config-file.txt #

function read_config_file() {
  local CONFIG_FILE=
  local NAME_SPACE=
  local test=
  local key=
  local value=
  local arr=
  local i=

  CONFIG_FILE="${THIS_FILE_PATH}/${BUILT_IN_FILE}"
  if [ -n "${1}" ]; then
    CONFIG_FILE=$1
  fi
  NAME_SPACE="default"
  if [ -n "${2}" ]; then
    NAME_SPACE=$2
  fi
  # get his content
  test=$(cat "$CONFIG_FILE")
  #echo "$test"
  # delete sh line comment
  test=$(echo "$test" | sed "s/^ *#.*//g")
  # delete space line
  test=$(echo "$test" | sed "/^$/d")
  #字符转为数组
  arr=($test)
  key=
  value=
  for i in "${arr[@]}"; do
    # 获取键名
    key=$(echo $i | awk -F'=' '{print $1}')
    # add ns to key
    #key="${NAME_SPACE}_${key}"

    #echo $key
    # 获取键值
    value=$(echo $i | awk -F'=' '{print $2}')
    # 输出该行
    #printf "%s\t\n" "$i"
    #echo $value
    cache_set_val "$key" "$value"
  done
  echo "read config file:$CONFIG_FILE"
}
# function-usage:
# read_config_file
# read_config_file a-config-file-2.txt
# read_config_file a-config-file-2.txt "ns"

function cache_read_built_in_config() {
  local PROJECT_PATH=
  local FILE_PATH=
  local CUSTOM_FILE=

  PROJECT_PATH=../
  if [ -n "${1}" ]; then
    PROJECT_PATH="${1}"
  fi
  #工程
  PROJECT_PATH=$(path_resolve $THIS_FILE_PATH $PROJECT_PATH)
  #目录
  FILE_PATH=dist #dist|./|test|...
  if [ -n "${2}" ]; then
    FILE_PATH="${2}"
  fi
  FILE_PATH=$(path_resolve $PROJECT_PATH $FILE_PATH)
  #echo $FILE_PATH
  #文件
  CUSTOM_FILE="a-config-file.txt"
  if [ -n "${3}" ]; then
    CUSTOM_FILE="${3}"
  fi
  #CUSTOM_FILE=$(cache_get_val_by_key "custom-file")
  CUSTOM_FILE=$(path_resolve $FILE_PATH $CUSTOM_FILE)
  mkdir -p $FILE_PATH

  NOT_READ=$(cache_get_arg_val "not-built-in")
  if [ -n "$NOT_READ" ]; then
    echo "does not read  the built in config.. " >/dev/null 2>&1
  else
    #echo "read  the built in config"
    if [[ -n "$CUSTOM_FILE" && -e $CUSTOM_FILE ]]; then
      #echo "read the file passed by cli args $CONFIG_FILE"
      read_config_file $CUSTOM_FILE "${CONFIG_BUILT_IN_PREFIX}_"
    fi
  fi
}
# function-usage:
# cache_read_built_in_config
# cache_read_built_in_config  "" "a-config-file.txt"

function cache_read_custom_config() {
  local PROJECT_PATH=
  local FILE_PATH=
  local CUSTOM_FILE=

  PROJECT_PATH=../
  if [ -n "${1}" ]; then
    PROJECT_PATH="${1}"
  fi
  #工程
  PROJECT_PATH=$(path_resolve $THIS_FILE_PATH $PROJECT_PATH)
  #目录
  FILE_PATH=dist #dist|./|test|...
  if [ -n "${2}" ]; then
    FILE_PATH="${2}"
  fi
  FILE_PATH=$(path_resolve $PROJECT_PATH $FILE_PATH)
  #echo $FILE_PATH
  #文件
  CUSTOM_FILE="a-config-file-2.txt"
  if [ -n "${3}" ]; then
    CUSTOM_FILE="${3}"
  fi
  #CUSTOM_FILE=$(cache_get_val_by_key "custom-file")
  CUSTOM_FILE=$(path_resolve $FILE_PATH $CUSTOM_FILE)
  mkdir -p $FILE_PATH
  if [[ -n "$CUSTOM_FILE" && -e $CUSTOM_FILE ]]; then
    #echo "read the file passed by cli args $CONFIG_FILE"
    read_config_file $CUSTOM_FILE "${CONFIG_CUSTOM_PREFIX}_"
  fi
}
# function-usage:
# cache_read_custom_config
# cache_read_custom_config "" "dist" "a-config-file-2.txt"

: <<simple-usage
#read_config_file

# read built in config file
#cache_read_built_in_config
#cache_read_built_in_config "" "dist" "a-config-file.txt"

# read custom config file
#cache_read_custom_config
#cache_read_custom_config "" "dist" "a-config-file-2.txt"
#cache_read_custom_config "" "dist" "a-config-file.txt"
#
#read custom config with arg custom-file xx
#note:need to use parse-passed-arg.sh
#CUSTOM_FILE=$(cache_get_val_by_key "custom-file")
#cache_read_custom_config "" "dist" "$CUSTOM_FILE"
# cache_ouput_val
simple-usage

## file usage
#./dist/read-from-file.sh --custom-file a-config-file-2.txt
