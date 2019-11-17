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
str1="${1}"
str2="${2}"
slpit_char1=/
slpit_char2=/
if [[ -n ${3} ]]
then
    slpit_char1=${3}
fi
if [[ -n ${4} ]]
then
    slpit_char2=${4}
fi
# 路径-转为数组
arr1=(${str1//$slpit_char1/ }) 
arr2=(${str2//$slpit_char2/ }) 

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
USAGE_MSG_FILE="${HELP_DIR}/write-docs.txt"
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
#echo $PROJECT_PATH
# 计算相关变量
ouput_debug_msg "caculate relations config ..." "true"
HELP_DIR=$PROJECT_PATH/help
SRC_DIR=$PROJECT_PATH/src
TEST_DIR=$PROJECT_PATH/test
DIST_DIR=$PROJECT_PATH/dist
DOCS_DIR=$PROJECT_PATH/docs
TOOL_DIR=$PROJECT_PATH//tool


#执行脚本目录
RUN_SCRIPT_PATH=$(pwd)
#脚本所在目录
#echo $THIS_FILE_PATH
#脚本工程目录
#SCRIPT_PROJECT_PATH

#echo  $PROJECT_PATH,$RUN_SCRIPT_PATH

# 生成相关目录
ouput_debug_msg "generate relations dir and file ..." "true"
mkdir -p $PROJECT_PATH

# 生成文档
function write_doc(){
DOC_FILE=$1 #from-a-config-file
mkdir -p $DOCS_DIR/how-to-use-for-dev/
cat > $DOCS_DIR/how-to-use-for-dev/${DOC_FILE}.md <<EOF
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
mkdir -p  $DOCS_DIR/how-to-use-for-dev/${DOC_LANG}/

cp $DOCS_DIR/how-to-use-for-dev/${DOC_FILE}.md $DOCS_DIR/how-to-use-for-dev/${DOC_LANG}/${DOC_FILE}.md
FILE_TO_WRITE_NOW=$DOCS_DIR/how-to-use-for-dev/${DOC_LANG}/${DOC_FILE}.md

sed -i "s/writes script file/编码脚本/g" $FILE_TO_WRITE_NOW
sed -i "s/lets script file has runable property/赋予权限/g" $FILE_TO_WRITE_NOW
sed -i "s/uses script file/使用脚本/g"  $FILE_TO_WRITE_NOW
sed -i "s/run as bash args/作为解释器参数/g"  $FILE_TO_WRITE_NOW
sed -i "s/run as runable application/作为可执行程序/g"  $FILE_TO_WRITE_NOW
sed -i "s/cd to file dir/切换到脚本所在目录/g"  $FILE_TO_WRITE_NOW
sed -i "s/cd to other dir/切换到其他目录执行/g"  $FILE_TO_WRITE_NOW

DOC_FILE=$1 #from-a-config-file
mkdir -p $DOCS_DIR/how-to-use-for-pro/
cat > $DOCS_DIR/how-to-use-for-pro/${DOC_FILE}.md <<EOF
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
mkdir -p  $DOCS_DIR/how-to-use-for-pro/${DOC_LANG}/
cp  $DOCS_DIR/how-to-use-for-pro/${DOC_FILE}.md   $DOCS_DIR/how-to-use-for-pro/${DOC_LANG}/${DOC_FILE}.md
FILE_TO_WRITE_NOW=$DOCS_DIR/how-to-use-for-pro/${DOC_LANG}/${DOC_FILE}.md
sed -i "s/uses script file/使用脚本/g" $FILE_TO_WRITE_NOW
sed -i "s/run as bash args/作为解释器参数/g" $FILE_TO_WRITE_NOW
sed -i "s/run as runable application/作为可执行程序/g" $FILE_TO_WRITE_NOW
sed -i "s/cd to file dir/切换到脚本所在目录/g" $FILE_TO_WRITE_NOW
sed -i "s/cd to other dir/切换到其他目录执行/g" $FILE_TO_WRITE_NOW

}


# 添加追踪（文档）文件
function git_add_docs_file(){
DOC_FILE=$1
DOC_LANG=$2
string=$(
cat << EOF
${DOCS_DIR}/how-to-use-for-dev/${DOC_FILE}.md
${DOCS_DIR}/how-to-use-for-dev/${DOC_LANG}/${DOC_FILE}.md
${DOCS_DIR}/how-to-use-for-pro/${DOC_FILE}.md
${DOCS_DIR}/how-to-use-for-pro/${DOC_LANG}/${DOC_FILE}.md
EOF
)
#echo $string
array=(${string//,/ })  
for var in ${array[@]}
do
   git add "$var"
done 
}

# 删除追踪（文档）文件
function git_delete_docs_file(){
DOC_FILE=$1
DOC_LANG=$2
string=$(
cat << EOF
${DOCS_DIR}/how-to-use-for-dev/${DOC_FILE}.md
${DOCS_DIR}/how-to-use-for-dev/${DOC_LANG}/${DOC_FILE}.md
${DOCS_DIR}/how-to-use-for-pro/${DOC_FILE}.md
${DOCS_DIR}/how-to-use-for-pro/${DOC_LANG}/${DOC_FILE}.md
EOF
)
#echo $string
array=(${string//,/ })  
for var in ${array[@]}
do
   #git reset HEAD "$var"
   #git checkout -- "$var"
   git rm "$var"
done 
}


# 生成（文档）文件readme.md头部
function generate_docs_index_head(){
cat > ${PROJECT_PATH}/readme.md <<EOF
# shell get config

## desc 

shell script get config lib
EOF
}

# 生成（文档）文件readme.md索引
function add_docs_index_to_readme(){
DOC_FILE=$1
DOC_LANG=$2
cat >> ${PROJECT_PATH}/readme.md <<EOF
## $DOC_FILE

how to use it with  developer? click below :

[en](./docs/how-to-use-for-dev/${DOC_FILE}.md) ,[${DOC_LANG}](./docs/how-to-use-for-dev/${DOC_LANG}/${DOC_FILE}.md)

how to use it with  production user?  click below :

[en](./docs/how-to-use-for-pro/${DOC_FILE}.md) ,[${DOC_LANG}](./docs/how-to-use-for-pro/${DOC_LANG}/${DOC_FILE}.md)
EOF
}

# 更新基础（文档）文件交版本库
function update_basic_docs_and_commit(){
cat > ${PROJECT_PATH}/.git/COMMIT_EDITMSG <<EOF
docs(core): updating basic docs
EOF
git commit --file ${PROJECT_PATH}/.git/COMMIT_EDITMSG
}

# 书写文档
if [ -n "$ARG_FILE_LIST" ]
then
    FILE_LIST=$(cat $(path_resolve $PROJECT_PATH $FILE_LIST))
fi
#echo $FILE_TO_WRITE_LIST
FILE_TO_WRITE_LIST_ARR=(${FILE_LIST//,/ })   
for var in ${FILE_TO_WRITE_LIST_ARR[@]}
do
   write_doc "$var" zh
done 
generate_docs_index_head
for var in ${FILE_TO_WRITE_LIST_ARR[@]}
do
   add_docs_index_to_readme "$var" zh
done

# 追踪文档
for var in ${FILE_TO_WRITE_LIST_ARR[@]}
do
   git_add_docs_file "$var" zh
done

#git add ${PROJECT_PATH}/readme.md
# 提交文档
#update_basic_docs_and_commit

# 不追踪它
#for var in ${FILE_TO_WRITE_LIST_ARR[@]}
#do
#   git_delete_docs_file "$var" zh
#done


#### usage
# bash ./write-docs.sh

#### 参考文献
:<<reference
# 

reference
