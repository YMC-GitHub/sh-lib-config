#!/bin/sh

declare -A aa403a
aa403a=()
# get cache dic var name by md5
#echo -n 'cache_dic'|md5sum|cut -d ' ' -f1|cut -c 1-6
# get cache dic var name by base64
#echo -n 'cache_dic'|base64|cut -d ' ' -f1|cut -c 1-6
# get cache dic var name by md5 and base64
#echo -n 'cache_dic' | base64 | md5sum | cut -d ' ' -f1 | cut -c 1-6

### cache config
KEY_ARG_PREFIX=$(echo -n 'arg' | md5sum | cut -d ' ' -f1)
KEY_BUILT_IN_PREFIX=$(echo -n 'built-in' | md5sum | cut -d ' ' -f1)
KEY_CUSTOM_PREFIX=$(echo -n 'custom' | md5sum | cut -d ' ' -f1)

### cache function
function cache_set_val() {
  local key=
  local val=
  key=$(echo "${1}" | sed "s/^--//g")
  val="${2}"
  aa403a+=(["$key"]="$val")
}
function cache_set_arg_val() {
  local key=
  local val=
  key=$(echo "${1}" | sed "s/^--//g")
  key="${KEY_ARG_PREFIX}_${key}"
  val="${2}"
  aa403a+=(["$key"]="$val")
}
function cache_set_bui_val() {
  local key=
  local val=
  key=$(echo "${1}" | sed "s/^--//g")
  key="${KEY_BUILT_IN_PREFIX}_${key}"
  val="${2}"
  aa403a+=(["$key"]="$val")
}
function cache_set_cus_val() {
  local key=
  local val=
  key=$(echo "${1}" | sed "s/^--//g")
  key="${KEY_CUSTOM_PREFIX}_${key}"
  val="${2}"
  aa403a+=(["$key"]="$val")
}
function cache_get_val() {
  local key=
  local val=
  # get val without  key prefix
  key=$(echo "${1}" | sed "s/^--//g")
  val=${aa403a[$key]}
  echo "$val"
}
function cache_get_arg_val() {
  local temp=
  local key=
  local val=
  # get val with arg key prefix
  key="${KEY_ARG_PREFIX}_${1}"
  val="${aa403a[$key]}"

  if [ -n "$val" ]; then
    temp="$val"
  fi
  echo "$temp"
}
function cache_get_bui_val() {
  local temp=
  local key=
  local val=
  # get val with arg key prefix
  key="${KEY_BUILT_IN_PREFIX}_${1}"
  val=${aa403a[$key]}
  if [ -n "$val" ]; then
    temp="$val"
  fi
  echo "$temp"
}
function cache_get_cus_val() {
  local temp=
  local key=
  local val=
  key="${KEY_CUSTOM_PREFIX}_${1}"
  #echo "$key"
  val=${aa403a[$key]}
  if [ -n "$val" ]; then
    temp="$val"
  fi
  echo "$temp"
}

function cache_get_val_by_key() {
  local temp=
  local key=
  local val=
  # get val without key prefix
  key="${1}"
  #echo "$key"
  val=${aa403a[$key]}
  if [ -n "$val" ]; then
    temp="$val"
  fi
  # get val with built in key prefix
  key="${KEY_BUILT_IN_PREFIX}_${1}"
  #echo "$key"
  val=${aa403a[$key]}
  if [ -n "$val" ]; then
    temp="$val"
  fi
  # get val with arg key prefix
  key="${KEY_ARG_PREFIX}_${1}"
  val=${aa403a[$key]}
  if [ -n "$val" ]; then
    temp="$val"
  fi
  # get val with custom key prefix
  key="${KEY_CUSTOM_PREFIX}_${1}"
  val=${aa403a[$key]}
  if [ -n "$val" ]; then
    temp="$val"
  fi
  echo "$temp"
}
function cache_ouput_val() {
  echo "config file all key: "
  echo ${!aa403a[*]}
  # 输出整个配置文件的键值
  echo "config file all val: "
  echo ${aa403a[*]}
}
