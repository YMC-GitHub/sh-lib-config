#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source "$THIS_FILE_PATH/sh-lib-path-resolve.sh"

PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
SRC_PATH=$(path_resolve "$PROJECT_PATH" "src")
NOTE_PATH=$(path_resolve "$PROJECT_PATH" "note")
BUILD_PATH=$(path_resolve "$PROJECT_PATH" "build")
PACKAGE_PATH=$(path_resolve "$PROJECT_PATH" "packages")
HELP_DIR=$(path_resolve $PROJECT_PATH "help")
SRC_DIR=$(path_resolve $PROJECT_PATH "src")
TEST_DIR=$(path_resolve $PROJECT_PATH "test")
DIST_DIR=$(path_resolve $PROJECT_PATH "dist")
DOCS_DIR=$(path_resolve $PROJECT_PATH "docs")
TOOL_DIR=$(path_resolve $PROJECT_PATH "tool")

RUN_SCRIPT_PATH="$THIS_FILE_PATH"
