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

FILE_LIST=$(
  cat <<EOF
from-cli-args
from-a-config-file
EOF
)

# 参数帮助信息
USAGE_MSG=
USAGE_MSG_PATH="$HELP_DIR"
USAGE_MSG_FILE="${HELP_DIR}/write-docs.txt"
USAGE_MSG=$(get_help_msg "$USAGE_MSG" "$USAGE_MSG_FILE")
# 缓存参数取值
GETOPT_ARGS_SHORT_RULE="--options h,d,"
GETOPT_ARGS_LONG_RULE="--long help,debug,project-path:,file-list:"
cache_args "$@"

#执行脚本目录
RUN_SCRIPT_PATH=$(pwd)
#脚本所在目录
#echo $THIS_FILE_PATH
#脚本工程目录
#SCRIPT_PROJECT_PATH

# 生成相关目录
ouput_debug_msg "generate relations dir and file ..." "true"
mkdir -p $PROJECT_PATH

# 生成文档
function write_doc() {
  local DOC_FILE=
  local DOC_FILE=
  local file=
  local classify=
  local path=
  local DOC_LANG=
  local src=
  local des=
  local txt=

  DOC_FILE="$1" #from-a-config-file
  DOC_LANG="$2"
  classify=how-to-use-for-dev
  path="$DOCS_DIR/$classify/"
  file="$path/${DOC_FILE}.md"

  # 创建相关目录
  mkdir -p "$path"
  cat >"$file" <<EOF
# how to use it with  developer?

\`\`\`sh
# writes script file
#cat ${DOC_FILE}.sh
# lets script file has runable property
#chmod +x ${DOC_FILE}.sh
# uses script file
#2 run as bash args
bash ./${DOC_FILE}.sh --help
#2 run as runable application
#3 cd to file dir
./${DOC_FILE}.sh --help
#3 cd to other dir
path/to/${DOC_FILE}.sh --help
\`\`\`
EOF

  DOC_LANG=$2 #zh
  path="$DOCS_DIR/$classify/$DOC_LANG/"
  des="$path/${DOC_FILE}.md"
  src="$file"
  file="$des"

  # create some dir
  mkdir -p "$path"
  # copy him
  cp "$src" "$des"

  # get his content
  txt=$(cat "$file")
  # update him
  txt=$(echo "$txt" | sed "s/writes script file/编码脚本/g")
  txt=$(echo "$txt" | sed "s/lets script file has runable property/赋予权限/g")
  txt=$(echo "$txt" | sed "s/uses script file/使用脚本/g")
  txt=$(echo "$txt" | sed "s/run as bash args/作为解释器参数/g")
  txt=$(echo "$txt" | sed "s/run as runable application/作为可执行程序/g")
  txt=$(echo "$txt" | sed "s/cd to file dir/切换到脚本所在目录/g")
  txt=$(echo "$txt" | sed "s/cd to other dir/切换到其他目录执行/g")
  echo "$txt" >"$file"

  classify=how-to-use-for-pro
  path="$DOCS_DIR/$classify/"
  file="$path/${DOC_FILE}.md"

  # 创建相关目录
  mkdir -p "$path"
  cat >"$file" <<EOF
# how to use it with  production user?

\`\`\`sh
# uses script file
#2 run as bash args
bash ./${DOC_FILE}.sh --help
#2 run as runable application
#3 cd to file dir
./${DOC_FILE}.sh --help
#3 cd to other dir
path/to/${DOC_FILE}.sh --help
\`\`\`
EOF

  path="$DOCS_DIR/$classify/$DOC_LANG/"
  des="$path/${DOC_FILE}.md"
  src="$file"
  file="$des"

  # create some dir
  mkdir -p "$path"
  # copy him
  cp "$src" "$des"
  # get his content
  txt=$(cat "$file")
  # update him
  txt=$(echo "$txt" | sed "s/uses script file/使用脚本/g")
  txt=$(echo "$txt" | sed "s/run as bash args/作为解释器参数/g")
  txt=$(echo "$txt" | sed "s/run as runable application/作为可执行程序/g")
  txt=$(echo "$txt" | sed "s/cd to file dir/切换到脚本所在目录/g")
  txt=$(echo "$txt" | sed "s/cd to other dir/切换到其他目录执行/g")
  echo "$txt" >"$file"
}

# 添加追踪（文档）文件
function git_add_docs_file() {
  local file=
  local lang=
  local str=
  local arr=
  local val=

  file=$1
  lang=$2
  str=$(
    cat <<EOF
${DOCS_DIR}/how-to-use-for-dev/${file}.md
${DOCS_DIR}/how-to-use-for-dev/${lang}/${file}.md
${DOCS_DIR}/how-to-use-for-pro/${file}.md
${DOCS_DIR}/how-to-use-for-pro/${lang}/${file}.md
EOF
  )
  #echo $str
  arr=(${str//,/ })
  for val in ${arr[@]}; do
    git add "$val"
  done
}

# 删除追踪（文档）文件
function git_delete_docs_file() {
  local file=
  local lang=
  local str=
  local arr=
  local val=

  file=$1
  lang=$2
  str=$(
    cat <<EOF
${DOCS_DIR}/how-to-use-for-dev/${file}.md
${DOCS_DIR}/how-to-use-for-dev/${lang}/${file}.md
${DOCS_DIR}/how-to-use-for-pro/${file}.md
${DOCS_DIR}/how-to-use-for-pro/${lang}/${file}.md
EOF
  )
  #echo $str
  arr=(${str//,/ })
  for val in ${arr[@]}; do
    #git reset HEAD "$var"
    #git checkout -- "$var"
    git rm "$val"
  done
}

# 生成（文档）文件readme.md头部
function generate_docs_index_head() {
  local file=
  local title=
  local desc=
  title="shell get config"
  if [ -n "$1" ]; then
    title="$1"
  fi
  desc="shell script get config lib"
  if [ -n "$2" ]; then
    desc="$2"
  fi
  file="${PROJECT_PATH}/readme.md"
  cat >"$file" <<EOF
# $title

## desc

$desc
EOF
}

# 生成（文档）文件readme.md索引
function add_docs_index_to_readme() {
  local DOC_FILE=
  local DOC_LANG=
  local file=
  DOC_FILE=$1
  DOC_LANG=$2
  file="${PROJECT_PATH}/readme.md"
  cat >>"$file" <<EOF
## $DOC_FILE

how to use it with  developer? click below :

[en](./docs/how-to-use-for-dev/${DOC_FILE}.md) ,[${DOC_LANG}](./docs/how-to-use-for-dev/${DOC_LANG}/${DOC_FILE}.md)

how to use it with  production user?  click below :

[en](./docs/how-to-use-for-pro/${DOC_FILE}.md) ,[${DOC_LANG}](./docs/how-to-use-for-pro/${DOC_LANG}/${DOC_FILE}.md)
EOF
}

# 更新基础（文档）文件交版本库
function update_basic_docs_and_commit() {
  local file=
  local msg=
  file="${PROJECT_PATH}/.git/COMMIT_EDITMSG "
  msg="docs(core): updating basic docs"
  if [ -n "$1" ]; then
    msg="$1"
  fi
  cat >"$file" <<EOF
$msg
EOF
  git commit --file "$file"
}

function main() {
  local list=
  local arr=
  local val=
  list=$(cache_get_arg_val "file-list")
  # 书写文档
  if [ -n "$list" ]; then
    list=$(cat $(path_resolve $PROJECT_PATH $list))
  fi
  #echo "$FILE_LIST"

  arr=(${list//,/ })
  # gen docs dir file
  for val in ${arr[@]}; do
    write_doc "$val" zh
  done
  # gen readme.md file
  generate_docs_index_head
  for val in ${arr[@]}; do
    add_docs_index_to_readme "$val" zh
  done

  # git add file
  for val in ${arr[@]}; do
    git_add_docs_file "$val" zh
  done
  # 不追踪它
  #for val in ${arr[@]}
  #do
  #   git_delete_docs_file "$val" zh
  #done
}
main
#git add ${PROJECT_PATH}/readme.md
# 提交文档
#update_basic_docs_and_commit

#### usage
# bash ./tool/write-docs.sh
