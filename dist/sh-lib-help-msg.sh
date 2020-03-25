#!/bin/sh

function get_help_msg() {
  local USAGE_MSG=
  local USAGE_MSG_FILE=

  USAGE_MSG="$1"
  USAGE_MSG_FILE="$2"
  if [ -z $USAGE_MSG ]; then
    if [[ -n $USAGE_MSG_FILE && -e $USAGE_MSG_FILE ]]; then
      USAGE_MSG=$(cat $USAGE_MSG_FILE)
    else
      USAGE_MSG="no help msg and file"
    fi
  fi
  echo "$USAGE_MSG"
}
