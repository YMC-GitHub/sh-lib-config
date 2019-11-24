#!/bin/sh

# 缓存管理器
# 特性：
# 读取键名
# 读取键值
# 设置前缀

declare -A dic
dic=()
THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
FILE_PATH=$THIS_FILE_PATH       #the default is relative tp the peoject dir
BUILT_IN_FILE=a-config-file.txt #
CONFIG_ARG_PREFIX=$(echo -n 'arg'|md5sum|cut -d ' ' -f1)
CONFIG_BUILT_IN_PREFIX=$(echo -n 'built-in'|md5sum|cut -d ' ' -f1)
CONFIG_CUSTOM_PREFIX=$(echo -n 'custom'|md5sum|cut -d ' ' -f1)
###
# 定义内置函数
###
function ouput_debug_msg() {
  local debug_msg=$1
  local debug_swith=$2
  if [[ "$debug_swith" =~ "false" ]]; then
    echo $debug_msg >/dev/null 2>&1
  elif [ -n "$debug_swith" ]; then
    echo $debug_msg
  elif [[ "$debug_swith" =~ "true" ]]; then
    echo $debug_msg
  fi
}
function path_resolve_for_relative() {
  local str1="${1}"
  local str2="${2}"
  local slpit_char1=/
  local slpit_char2=/
  if [[ -n ${3} ]]; then
    slpit_char1=${3}
  fi
  if [[ -n ${4} ]]; then
    slpit_char2=${4}
  fi

  # 路径-转为数组
  local arr1=(${str1//$slpit_char1/ })
  local arr2=(${str2//$slpit_char2/ })

  # 路径-解析拼接
  #2 遍历某一数组
  #2 删除元素取值
  #2 获取数组长度
  #2 获取数组下标
  #2 数组元素赋值
  for val2 in ${arr2[@]}; do
    length=${#arr1[@]}
    if [ $val2 = ".." ]; then
      index=$(($length - 1))
      if [ $index -le 0 ]; then index=0; fi
      unset arr1[$index]
      #echo ${arr1[*]}
      #echo  $index
    elif [ $val2 = "." ]
    then
        echo "it is current file" > /dev/null 2>&1
    else
      index=$length
      arr1[$index]=$val2
      #echo ${arr1[*]}
    fi
  done
  # 路径-转为字符
  local str3=''
  for i in ${arr1[@]}; do
    str3=$str3/$i
  done
  if [ -z $str3 ]; then str3="/"; fi
  echo $str3
}
function path_resolve() {
  local str1="${1}"
  local str2="${2}"
  local slpit_char1=/
  local slpit_char2=/
  if [[ -n ${3} ]]; then
    slpit_char1=${3}
  fi
  if [[ -n ${4} ]]; then
    slpit_char2=${4}
  fi

  #FIX:when passed asboult path,dose not return the asboult path itself
  #str2="/d/"
  local str3=""
  str2=$(echo $str2 | sed "s#/\$##")
  ABSOLUTE_PATH_REG_PATTERN="^/"
  if [[ $str2 =~ $ABSOLUTE_PATH_REG_PATTERN ]]; then
    str3=$str2
  else
    str3=$(path_resolve_for_relative $str1 $str2 $slpit_char1 $slpit_char2)
  fi
  echo $str3
}
function get_help_msg() {
  local USAGE_MSG=$1
  local USAGE_MSG_FILE=$2
  if [ -z $USAGE_MSG ]; then
    if [[ -n $USAGE_MSG_FILE && -e $USAGE_MSG_FILE ]]; then
      USAGE_MSG=$(cat $USAGE_MSG_FILE)
    else
      USAGE_MSG="no help msg and file"
    fi
  fi
  echo "$USAGE_MSG"
}
function read_config_file() {
  # echo ${THIS_FILE_PATH}
  local CONFIG_FILE=${THIS_FILE_PATH}/from-a-config.txt
  if [ -n "${1}" ]; then
    CONFIG_FILE=$1
  fi
  NAME_SPACE="default"
  if [ -n "${2}" ]; then
    NAME_SPACE=$2
  fi

  local test=$(sed 's/^ *//g' $CONFIG_FILE | grep --invert-match "^#")
  #字符转为数组
  local arr=($test)
  local key=
  local value=
  for i in "${arr[@]}"; do
    # 获取键名
    key=$(echo $i | awk -F'=' '{print $1}')
    key="${NAME_SPACE}_${key}"
    #echo $key
    # 获取键值
    value=$(echo $i | awk -F'=' '{print $2}')
    # 输出该行
    #printf "%s\t\n" "$i"
    #echo $value
    dic+=([$key]=$value)
  done
  echo "read config file:$CONFIG_FILE"
}
# function-usage:
# read_config_file
# read_config_file a-config-file-2.txt

###
#cache public func
###
function cache_set_val(){
  local key=$(echo "${1}"|sed "s/^--//g")
  local val="${2}"
  dic+=([$key]=$value)
}

function cache_set_arg_val(){
  local key=
  key=$(echo "${1}"|sed "s/^--//g")
  key="${CONFIG_ARG_PREFIX}_${key}"
  local val="${2}"
  dic+=([$key]=$value)
}
function cache_get_val_by_key(){
    local temp=
    local key=
    local val=
    key="${CONFIG_BUILT_IN_PREFIX}_${1}"
    #echo "$key"
    val=${dic[$key]}
    if [ -n "$val" ]
    then
        temp="$val"
    fi
    key="${CONFIG_ARG_PREFIX}_${1}"
    val=${dic[$key]}
    if [ -n "$val" ]
    then
        temp="$val"
    fi
    key="${CONFIG_CUSTOM_PREFIX}_${1}"
    val=${dic[$key]}
    if [ -n "$val" ]
    then
        temp="$val"
    fi
    echo "$temp"
}


function cache_read_built_in_config(){
  local FILE=$THIS_FILE_PATH/$BUILT_IN_FILE
if [ -n "$ARG_NO_BUILT_IN" ]; then
  echo "does not read  the built in config.. " >/dev/null 2>&1
else
  #echo "read  the built in config"
  read_config_file $FILE "$CONFIG_BUILT_IN_PREFIX"
fi
}
function cache_read_custom_config(){
  local PROJECT_PATH=../
  if [ -n "${1}" ]
  then
      PROJECT_PATH="${1}"
  fi
  #工程
  PROJECT_PATH=$(path_resolve $THIS_FILE_PATH $PROJECT_PATH)
  #目录
  local FILE_PATH=dist #dist|./|test|...
  if [ -n "${2}" ]
  then
      FILE_PATH="${2}"
  fi
  FILE_PATH=$(path_resolve $PROJECT_PATH $FILE_PATH)
  #echo $FILE_PATH
  #文件
  local CUSTOM_FILE=$(cache_get_val_by_key "custom-file")
  CUSTOM_FILE=$(path_resolve $FILE_PATH $CUSTOM_FILE)
  #echo "file is $CUSTOM_FILE"
  if [ -n "${2}" ]
  then
      CUSTOM_FILE="$FILE_PATH/${2}"
  fi
  mkdir -p $FILE_PATH
  if [[ -n "$CUSTOM_FILE" && -e $CUSTOM_FILE ]]; then
    #echo "read the file passed by cli args $CONFIG_FILE"
    read_config_file $CUSTOM_FILE "$CONFIG_CUSTOM_PREFIX"
  fi
}
function cache_ouput_config(){
echo "config file all key: "
echo ${!dic[*]}
# 输出整个配置文件的键值
echo "config file all val: "
echo ${dic[*]}
}
#read_built_in_config