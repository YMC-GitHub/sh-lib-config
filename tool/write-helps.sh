#!/bin/sh
#### 它是什么
# 

#### 为什么要
# 

#### 如何进行
# 

# 定义内置变量
# ...
FILE_LIST=$(
cat << EOF
from-cli-args
from-a-config-file
write-docs
EOF
)

# 定义内置函数
# ...
function ouput_debug_msg(){
local debug_msg=$1
local debug_swith=$2
if [[ "$debug_swith" =~ "false" ]] ; 
then 
    echo $debug_msg > /dev/null 2>&1
elif [ -n "$debug_swith" ]
then
    echo $debug_msg ; 
elif [[ "$debug_swith" =~ "true" ]] ; 
then
    echo $debug_msg ; 
fi
}

function path_resolve(){
local str1="${1}"
local str2="${2}"
local slpit_char1=/
local slpit_char2=/
local length=
local index=
if [[ -n ${3} ]]
then
    slpit_char1=${3}
fi
if [[ -n ${4} ]]
then
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

for val2 in ${arr2[@]}  
do   
    length=${#arr1[@]}
    if [ $val2 = ".." ]
    then
        index=$[$length-1]
        if [ $index -le 0 ] ; then index=0; fi
        unset arr1[$index]  
        #echo ${arr1[*]}
        #echo  $index
    else
        index=$length
        arr1[$index]=$val2
        #echo ${arr1[*]}
    fi
done
# 路径-转为字符
str2=''
for i in ${arr1[@]};do
  str2=$str2/$i;
done
 if [ -z $str2 ] ; then str2="/"; fi
echo $str2
}

# 引入相关文件
THIS_FILE_PATH=$(cd `dirname $0`; pwd)
# source $THIS_FILE_PATH/path-resolve.sh
# 工程目录信息
PROJECT_PATH=$(path_resolve $THIS_FILE_PATH "../")
HELP_DIR=$(path_resolve $THIS_FILE_PATH "../help")
SRC_DIR=$(path_resolve $THIS_FILE_PATH "../src")
TEST_DIR=$(path_resolve $THIS_FILE_PATH "../test")
DIST_DIR=$(path_resolve $THIS_FILE_PATH "../dist")
DOCS_DIR=$(path_resolve $THIS_FILE_PATH "../docs")
TOOL_DIR=$(path_resolve $THIS_FILE_PATH "../tool")
# 参数帮助信息
USAGE_MSG_PATH="$HELP_DIR"
USAGE_MSG_FILE="${HELP_DIR}/write-helps.txt"
# 参数规则内容
GETOPT_ARGS_SHORT_RULE="--options h,d,"
GETOPT_ARGS_LONG_RULE="--long help,debug,file-list:,project-path:"
# 设置参数规则
GETOPT_ARGS=`getopt $GETOPT_ARGS_SHORT_RULE \
$GETOPT_ARGS_LONG_RULE -- "$@"`
# 解析参数规则
ouput_debug_msg "pasre cli args ..." "true"
eval set -- "$GETOPT_ARGS"
while [ -n "$1" ]
do
    case $1 in
    --file-list)
    ARG_FILE_LIST=$2
    shift 2
    ;;
    --project-path)
    ARG_PROJECT_PATH=$2
    shift 2
    ;;
    -h|--help)
    #echo "$USAGE_MSG_FILE"
    cat $USAGE_MSG_FILE
    exit 1
    ;;
    -d|--debug)
    IS_DEBUG_MODE=true
    shift 2
    ;;
    --)
    break
    ;;
    *)
    printf "$USAGE_MSG"
    ;;
    esac
done
# 处理剩余参数
ouput_debug_msg "handle the rest args ..." "true"
# 更新内置变量
if [ -n "$ARG_FILE_LIST" ]
then
    FILE_LIST=$ARG_FILE_LIST
fi
if [ -n "$ARG_PROJECT_PATH" ]
then
    # 如果传入工程目录，工程目录是相对目录，则相对于本脚本工程目录
    PROJECT_PATH=$(path_resolve $PROJECT_PATH $ARG_PROJECT_PATH)
    # 如果传入工程目录，工程目录是相对目录，则相对于执行本脚本的当前目录
    #PROJECT_PATH=$(path_resolve $(pwd) $ARG_PROJECT_PATH)
    # 如果传入工程目录，工程目录是相对目录，则相对于本脚本所在目录
    #PROJECT_PATH=$(path_resolve $THIS_FILE_PATH $ARG_PROJECT_PATH)
fi
# 输出内置变量
ouput_debug_msg "ouput built-in var..." "true"
#echo $FILE_LIST,$PROJECT_PATH
# 计算相关变量
ouput_debug_msg "caculate relations config ..." "true"
:<<delete-01
HELP_DIR=$(path_resolve $PROJECT_PATH "../help")
SRC_DIR=$(path_resolve $PROJECT_PATH "../src")
TEST_DIR=$(path_resolve $PROJECT_PATH "../test")
DIST_DIR=$(path_resolve $PROJECT_PATH "../dist")
DOCS_DIR=$(path_resolve $PROJECT_PATH "../docs")
TOOL_DIR=$(path_resolve $PROJECT_PATH "../tool")
delete-01
# 生成相关目录
ouput_debug_msg "generate relations dir and file ..." "true"


FILE_NAME=write-docs
FILE_PATH=src

function get_part(){
FLAG_SYMBOL=desc
if [[ -n "$1" ]]
then
    FLAG_SYMBOL=$1
fi
# the begining flag of the section
BeginFlag="<$FLAG_SYMBOL>"
# the ending flag of the section
EndFlag="<$FLAG_SYMBOL/>"

declare -i Bnum
declare -i Enum
declare -i nums
FILE=$FILE_PATH/$FILE_NAME.help.tpl #$1
# line number of the beginning flag
Bnum=$(grep -n "$BeginFlag" $FILE | cut -d: -f1)
# line number of the ending flag
Enum=$(grep -n "$EndFlag" $FILE | cut -d: -f1)
# lines between the begining and ending flag
nums=$(($Enum-$Bnum))
#echo $Bnum,$Enum,$nums
# output the result into stdout
PART_CONTENT=$(grep -A $nums "$BeginFlag" $FILE|sed "s#<$FLAG_SYMBOL>#$FLAG_SYMBOL:#" |sed "s#<$FLAG_SYMBOL/>##" )
echo "$PART_CONTENT"
}

function write_doc(){

local FILE_NAME=
local FILE_PATH="$SRC_DIR"
if [[ -n "$1" ]]
then
    FILE_NAME=$1
fi
if [[ -n "$2" ]]
then
    FILE_PATH=$(path_resolve $PROJECT_PATH $2)
fi

# question:.help.txts  /d/code-store/Shell/shell-get-config/src/from-cli-args
#https://blog.csdn.net/hefrankeleyn/article/details/85287391
echo "write docs  ${FILE_PATH}/${FILE_NAME}.help.txt"

local part_desc=$(get_part desc)
local part_args=$(get_part args)
local part_how_to_run=$(get_part how-to-run)
local part_demo_with_args=$(get_part demo-with-args)
local part_how_to_get_help=$(get_part how-to-get-help)

cat > ${FILE_PATH}/${FILE_NAME}.help.txt<<eof
$part_desc
$part_args
$part_how_to_run
$part_demo_with_args
$part_how_to_get_help
eof
echo "write docs help/$FILE_NAME.txt"
cp -f $FILE_PATH/$FILE_NAME.help.txt help/$FILE_NAME.txt
}

if [ -n "$ARG_FILE_LIST" ]
then
    FILE_LIST=$(cat $(path_resolve $PROJECT_PATH $FILE_LIST))
fi
#echo "$FILE_LIST"


FILE_TO_WRITE_LIST_ARR=(${FILE_LIST//,/ })  

for var in ${FILE_TO_WRITE_LIST_ARR[@]}
do
   write_doc "$var" src
done 

# 追踪文档
for var in ${FILE_TO_WRITE_LIST_ARR[@]}
do
   echo "git add help docs help/$var.txt"
   git add "help/$var.txt" 
done

#### usage
# bash ./write-helps.sh

#### 参考文献
:<<reference
# 

reference
