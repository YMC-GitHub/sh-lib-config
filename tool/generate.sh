#!/bin/sh


# 定义内置配置
THIS_FILE_PATH=$(cd `dirname $0`; pwd)
ARG_LIST=
FILE_NAME=main
FILE_PATH=$THIS_FILE_PATH

# 定义内置函数
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

# 文档帮助信息
USAGE_MSG=$(cat<<EOF 
genarate basic sh file
args:
  --file-name optional,set the ouput file name
  --file-path optional,set the ouput file path
  -d,--debug optional,set the debug mode
  -h,--help optional,get the cmd help
examples: 
  run as shell args
bash ./generate.sh
  run as runable application
./generate.sh --file-name eth0

  without args: 
./generate.sh 
  with args: 
./generate.sh --file-name eth0

  with debug mode: 
./generate.sh --debug

get help: 
./generate.sh --help
EOF
)
USAGE_MSG=$(cat<<EOF 
$USAGE_MSG

basic usage: 
 set the file name
./generate.sh --file-name main

 set the file path
 case)set a relative path
./generate.sh --file-path ../src
 case)set a absoulte path
./generate.sh --file-path /

built-in config var:
FILE_NAME=
FILE_PATH=
EOF
)


# 参数规则内容
GETOPT_ARGS_SHORT_RULE="--options h,d"
GETOPT_ARGS_LONG_RULE="--long help,debug,file-name:,file-path:"

# 设置参数规则
GETOPT_ARGS=`getopt $GETOPT_ARGS_SHORT_RULE \
$GETOPT_ARGS_LONG_RULE -- "$@"`
# 解析参数规则
eval set -- "$GETOPT_ARGS"
while [ -n "$1" ]
do
    case $1 in
    --file-name)
    ARG_FILE_NAME=$2
    shift 2
    ;;
    --file-path)
    ARG_FILE_PATH=$2
    shift 2
    ;;
    -h|--help) #可选，不接参数
    echo "$USAGE_MSG"
    exit 1
    ;;
    -d|--debug) #可选，不接参数
    IS_DEBUG_MODE=true
    shift 2
    ;;
    --)
    break
    ;;
    *)
    echo "$USAGE_MSG"
    ;;
    esac
done
# 处理剩余参数

# 更新内置变量
if [ -n "$ARG_FILE_NAME" ]
then
    FILE_NAME=$ARG_FILE_NAME
fi
if [ -n "$ARG_FILE_PATH" ]
then
    FILE_PATH=$(path_resolve $FILE_PATH $ARG_FILE_PATH)
fi
# 计算相关变量
OUTPUT_FILE=$FILE_PATH/$FILE_NAME.sh

# add multi line text to a var
ouput_debug_msg "生成输入文件 ..." "true"
ARG_LIST_DESC=$(cat<<ARG-LIST-EOF
  -s,--sdate optional,passed arg with necessary value
  -e,--edate optional,passed arg with optional value
  -n,--numprocs optional,passed arg without value
ARG-LIST-EOF
)
ARG_LIST=$(echo "$ARG_LIST_DESC" |sed "s/-.,//g" |sed "s/optional.*//g")
#echo "$ARG_LIST_DESC"
#echo "$ARG_LIST"
ARG_SHORT_LONG_MAP=$(echo "$ARG_LIST_DESC" |sed "s/optional.*//g"| sed "s/ *//g"| sed "s/,/=/g")
#echo "$ARG_SHORT_LONG_MAP"

declare -A DIC_ARG_SHORT_LONG_MAP
DIC_ARG_SHORT_LONG_MAP=()
test=`echo $ARG_SHORT_LONG_MAP`
#echo $test
slpit_char=" "
#字符转为数组
arr=(${test//$slpit_char/ }) 
key=
value=
for i in "${arr[@]}"; do
    
    # 获取键值：小写+中划
    value=`echo $i |cut -d "=" -f 1 |tr "[:upper:]" "[:lower:]" |sed "s/-//g"`
    # 获取键名:小写
    key=`echo $i |cut -d "=" -f 2|tr "[:upper:]" "[:lower:]" |sed "s/--//g"`
    #echo $key,$value
    DIC_ARG_SHORT_LONG_MAP+=([$key]=$value)
done
#echo "${DIC_ARG_SHORT_LONG_MAP['sdate']}"

ouput_debug_msg "读取输入文件 ..." "true"
declare -A dic
#设置二维数组
dic=()
test=`echo "$ARG_LIST"`
#字符转为数组
arr=($test)
key=
value=
for i in "${arr[@]}"; do
    # 获取键名:小写+中划
    key=`echo $i|tr "[:upper:]" "[:lower:]"  | sed "s/--//g"`
    # 获取键值：大写+下划+前缀
    value=`echo $i|tr "[:lower:]" "[:upper:]" | sed "s/--/ARG_/g" |sed "s/-/_/g"`
    dic+=([$key]=$value)
done

ouput_debug_msg "生成相关内容 ..." "true"
echo "#!/bin/sh" > $OUTPUT_FILE

ouput_debug_msg "文档它是什么" "true"
cat >> $OUTPUT_FILE << EOF
#### 它是什么
# 

EOF

ouput_debug_msg "文档为什么要" "true"
cat >> $OUTPUT_FILE << EOF
#### 为什么要
# 

EOF

ouput_debug_msg "文档如何进行" "true"
cat >> $OUTPUT_FILE << EOF
#### 如何进行
# 

EOF

ouput_debug_msg "定义内置变量" "true"
cat >> $OUTPUT_FILE << EOF
# 定义内置变量
# ...
EOF

ouput_debug_msg "定义内置函数" "true"
cat >> $OUTPUT_FILE << EOF
# 定义内置函数
# ...
function ouput_debug_msg(){
local debug_msg=\$1
local debug_swith=\$2
if [[ "\$debug_swith" =~ "false" ]] ; 
then 
    echo \$debug_msg > /dev/null 2>&1
elif [ -n "\$debug_swith" ]
then
    echo \$debug_msg ; 
elif [[ "\$debug_swith" =~ "true" ]] ; 
then
    echo \$debug_msg ; 
fi
}

function path_resolve(){
str1="\${1}"
str2="\${2}"
slpit_char1=/
slpit_char2=/
if [[ -n \${3} ]]
then
    slpit_char1=\${3}
fi
if [[ -n \${4} ]]
then
    slpit_char2=\${4}
fi
# 路径-转为数组
arr1=(\${str1//\$slpit_char1/ }) 
arr2=(\${str2//\$slpit_char2/ }) 

# 路径-解析拼接
#2 遍历某一数组
#2 删除元素取值
#2 获取数组长度
#2 获取数组下标
#2 数组元素赋值

for val2 in \${arr2[@]}  
do   
    length=\${#arr1[@]}
    if [ \$val2 = ".." ]
    then
        index=\$[$length-1]
        if [ \$index -le 0 ] ; then index=0; fi
        unset arr1[$index]  
        #echo \${arr1[*]}
        #echo  \$index
    else
        index=\$length
        arr1[\$index]=\$val2
        #echo \${arr1[*]}
    fi
done
# 路径-转为字符
str2=''
for i in \${arr1[@]};do
  str2=\$str2/\$i;
done
 if [ -z \$str2 ] ; then str2="/"; fi
echo \$str2
}
EOF


ouput_debug_msg "引入相关文件" "true"
cat >> $OUTPUT_FILE << EOF
# 引入相关文件
THIS_FILE_PATH=\$(cd \`dirname \$0\`; pwd)
source \$THIS_FILE_PATH/path-resolve.sh
EOF

ouput_debug_msg "参数帮助信息" "true"
cat >> $OUTPUT_FILE << EOF
# 参数帮助信息
HELP_DIR=\$(path_resolve \$THIS_FILE_PATH "../help")
USAGE_MSG_PATH="\$HELP_DIR"
USAGE_MSG_FILE="\${HELP_DIR}/$FILE_NAME.txt"
EOF

ouput_debug_msg "参数规则内容" "true"
ARGS_RULE_SHORT_TXT=
for i in $(echo ${DIC_ARG_SHORT_LONG_MAP[*]})
do
    # 小写
    key=`echo $i|tr "[:upper:]" "[:lower:]"`
    ARGS_RULE_SHORT_TXT="${ARGS_RULE_SHORT_TXT}${key}:,"
done
ARGS_RULE_SHORT_TXT=$(echo $ARGS_RULE_SHORT_TXT | sed "s/,$//g")

ARGS_RULE_TXT=""
for i in $(echo ${!dic[*]})
do
    # 小写+中划
    key=`echo $i|tr "[:upper:]" "[:lower:]"  | sed "s/--//g"`
    ARGS_RULE_TXT="${ARGS_RULE_TXT}${key}:,"
done
ARGS_RULE_TXT=$(echo $ARGS_RULE_TXT | sed "s/,$//g")

ARGS_RULE_TXT=$(cat<<ARG-LIST-EOF
GETOPT_ARGS_SHORT_RULE="--options h,d,$ARGS_RULE_SHORT_TXT"
GETOPT_ARGS_LONG_RULE="--long help,debug,$ARGS_RULE_TXT"
ARG-LIST-EOF
)
cat >> $OUTPUT_FILE << EOF
# 参数规则内容
$ARGS_RULE_TXT
EOF
#echo "$ARGS_RULE_TXT" >> $OUTPUT_FILE


ouput_debug_msg "设置参数规则" "true"
SET_ARGS_RULE_TXT=
#echo "$SET_ARGS_RULE_TXT"
cat >> $OUTPUT_FILE << EOF
# 设置参数规则
GETOPT_ARGS=\`getopt \$GETOPT_ARGS_SHORT_RULE \\
\$GETOPT_ARGS_LONG_RULE -- "\$@"\`
EOF

ouput_debug_msg "解析参数规则" "true"
PARSE_ARGS_TXT=$(cat<<ARG-LIST-EOF
while [ -n "\$1" ]
do
    case \$1 in
ARG-LIST-EOF
)
#echo "$PARSE_ARGS_TXT"

for i in $(echo ${!dic[*]})
do
    # 小写+中划
    key="$i"
    # 大写+下划+前缀
    val=${dic[$i]}
    short_val=${DIC_ARG_SHORT_LONG_MAP[$key]}
    if [ -n "$short_val" ] ; 
    then 

        key="-$short_val|--$key";
    else
        key="--$key";
    fi
    #echo $key
    PARSE_ARGS_TXT=$(cat<<ARG-LIST-EOF
$PARSE_ARGS_TXT
    $key)
    $val=\$2
    shift 2
    ;;
ARG-LIST-EOF
)
done

PARSE_ARGS_TXT=$(cat<<ARG-LIST-EOF
$PARSE_ARGS_TXT
    -h|--help)
    #echo "\$USAGE_MSG_FILE"
    cat \$USAGE_MSG_FILE
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
    printf "\$USAGE_MSG"
    ;;
    esac
done
ARG-LIST-EOF
)
cat >> $OUTPUT_FILE << EOF
# 解析参数规则
ouput_debug_msg "pasre cli args ..." "true"
eval set -- "\$GETOPT_ARGS"
$PARSE_ARGS_TXT
EOF
#echo "$PARSE_ARGS_TXT"  >> $OUTPUT_FILE

cat >> $OUTPUT_FILE << EOF
# 处理剩余参数
ouput_debug_msg "handle the rest args ..." "true"
EOF



ouput_debug_msg "更新内置变量" "true"
for i in $(echo ${!dic[*]})
do
    # 大写+下滑
    key=`echo $i|tr "[:lower:]" "[:upper:]" | sed "s/-/_/g"`
    # 大写+下划+前缀
    val=${dic[$i]}
    UPDATE_BUILT_IN_CONFIG_TXT=$(cat<<UPDATE-BUILT-IN-CONFIG
$UPDATE_BUILT_IN_CONFIG_TXT
if [ -n "\$$val" ]
then
    $key=\$$val
fi
UPDATE-BUILT-IN-CONFIG
)
done

#echo "# 更新内置变量" >> $OUTPUT_FILE
#echo "$UPDATE_BUILT_IN_CONFIG_TXT"  >> $OUTPUT_FILE
cat >> $OUTPUT_FILE << EOF
# 更新内置变量
$UPDATE_BUILT_IN_CONFIG_TXT
EOF

ouput_debug_msg "输出内置变量" "true"
BUIT_IN_VAR_TXT=
for i in $(echo ${!dic[*]})
do
    # 大写+下滑
    key=`echo $i|tr "[:lower:]" "[:upper:]" | sed "s/-/_/g"`
    BUIT_IN_VAR_TXT="${BUIT_IN_VAR_TXT},${key}"
done
BUIT_IN_VAR_TXT=$(echo $BUIT_IN_VAR_TXT | sed "s/,/,$/g" |sed "s/^,//g" )
#echo $BUIT_IN_VAR_TXT

cat >> $OUTPUT_FILE << EOF
# 输出内置变量
ouput_debug_msg "ouput built-in var..." "true"
echo $BUIT_IN_VAR_TXT
EOF

ouput_debug_msg "计算相关变量" "true"
cat >> $OUTPUT_FILE << EOF
# 计算相关变量
ouput_debug_msg "caculate relations config ..." "true"
EOF

ouput_debug_msg "生成相关目录" "true"
cat >> $OUTPUT_FILE << EOF
# 生成相关目录
ouput_debug_msg "generate relations dir and file ..." "true"
EOF


ouput_debug_msg "文档基本用法" "true"
cat >> $OUTPUT_FILE << EOF
#### usage
# bash ./$FILE_NAME.sh

EOF

ouput_debug_msg "文档参考文献" "true"
cat >> $OUTPUT_FILE << EOF
#### 参考文献
:<<reference
# 

reference
EOF


# usage
# ./tool/generate.sh --help
# ./tool/generate.sh