#!/bin/sh

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
