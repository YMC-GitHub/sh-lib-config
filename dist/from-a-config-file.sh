#!/bin/sh

# 读取配置文件
# 需要：
# 去除行首空格
# 去除注释内容
# 分割各键值对
# 分割键名键值

#创建二维数组
declare -A dic
#设置二维数组
dic=()


THIS_FILE_PATH=$(cd `dirname $0`; pwd)
source $THIS_FILE_PATH/path-resolve.sh
# 帮助信息
HELP_DIR=$(path_resolve $THIS_FILE_PATH "../help")
USAGE_MSG_FILE=${HELP_DIR}/from-a-config-file.txt

# 参数规则
GETOPT_ARGS_SHORT_RULE="--options h,f::,d"
GETOPT_ARGS_LONG_RULE="--long help,file::,debug"

# 设置参数规则
GETOPT_ARGS=`getopt $GETOPT_ARGS_SHORT_RULE \
$GETOPT_ARGS_LONG_RULE -- "$@"`
# 解析参数规则
eval set -- "$GETOPT_ARGS"
# 更新新的配置
CONFIG_FILE=
while [ -n "$1" ]
do
    case $1 in
    -f|--file) #可选，可接可不接参数
    CONFIG_FILE=$2
    #echo $CONFIG_FILE 
    shift 2
    ;;
    -h|--help) #可选，不接参数
    cat $USAGE_MSG_FILE
    exit 1
    ;;
    -d|--debug) #可选，不接参数
    IS_DEBUG_MODE=true
    ;;
    --)
    break
    ;;
    *)
    printf "$USAGE_MSG"
    ;;
    esac
done

function ouput_debug_msg(){
local debug_msg=$1
if [[ "$IS_DEBUG_MODE" =~ "true" ]] ; 
then 
    echo $debug_msg ; 
fi 
}

if [[ "$CONFIG_FILE" =~ "^/" ]] ;
then
    ouput_debug_msg "absolute path"
else
    CONFIG_FILE=$(echo $CONFIG_FILE | sed "s#./##g")
    ouput_debug_msg "will read custom file in relative path:$THIS_FILE_PATH/$CONFIG_FILE"
    CONFIG_FILE=$THIS_FILE_PATH/$CONFIG_FILE
fi
#处理剩余的参数
:<<handle-rest-args
for arg in $@
do
    echo "processing $arg"
done
handle-rest-args

function read_config_file(){
# echo ${THIS_FILE_PATH}
local CONFIG_FILE=${THIS_FILE_PATH}/a-config-file.txt
if [ -n "${1}" ]
then
    CONFIG_FILE=$1
fi
local test=`sed 's/^ *//g' $CONFIG_FILE | grep --invert-match "^#"`
#字符转为数组
local arr=($test)
local key=
local value=
for i in "${arr[@]}"; do
    # 获取键名
    key=`echo $i|awk -F'=' '{print $1}'`
    # 获取键值
    value=`echo $i|awk -F'=' '{print $2}'`
    # 输出该行
    #printf "%s\t\n" "$i"
    dic+=([$key]=$value)
done
echo "read confifg file:$CONFIG_FILE"
}
# function-usage:
# read_config_file 
# read_config_file a-config-file-2.txt 

#读取配置文件
echo "read built-in config:..."
#fix sed: can't read a-config-file.txt: No such file or directory with index.sh

read_config_file

#2输出某个键值
:<<ouput-one-key-val-for-debug
if [ ${dic["key1"]} ] ; then
    echo ${dic["key1"]}
fi
if [ ${dic["k8s-master"]} ] ; then
    echo ${dic["k8s-master"]}
fi
ouput-one-key-val-for-debug
#2输出整个配置
#echo ${dic[*]}

echo "read custom config:..."
#read_config_file a-config-file-2.txt 
#fix: No such file or directory
if [[ -n $CONFIG_FILE && -e $CONFIG_FILE ]]
then
    #echo "read the file passed by cli args $CONFIG_FILE"
    read_config_file $CONFIG_FILE
fi

#:<<ouput-config-key-val-for-debug
# 输出整个配置文件的键名
echo "config file all key: "
echo ${!dic[*]}
# 输出整个配置文件的键值
echo "config file all val: "
echo ${dic[*]}
# 输出整个配置某个的键值
echo "config file key k8s-worker-7 's val is: "
if [ ${dic["k8s-worker-7"]} ] ; then
    echo ${dic["k8s-worker-7"]}
fi
#ouput-config-key-val-for-debug

# 基本用法
:<<how-to-use-for-pro
#作为解释器参数
bash ./from-a-config-file.sh
bash ./from-a-config-file.sh --file=a-config-file-2.txt 
#作为可执行程序
#2 切换到脚本所在目录
./from-a-config-file.sh --file=a-config-file-2.txt 
#2 切换到其他目录执行
shell-get-config/from-a-config-file.sh --file=a-config-file-2.txt
#获取帮助
./from-a-config-file.sh --help

shell-get-config/from-a-config-file.sh --help
how-to-use-for-pro

# 生成序列数组性能比较
:<<compare-feat-to-create-deq-arr
time echo {1..100}
time echo $(seq 100)
compare-feat-to-create-deq-arr
#### 参考文献
:<<reference
shell awk命令详解（格式+使用方法）
http://c.biancheng.net/view/992.html

Shell通过特定字符把字符串分割成数组
https://blog.csdn.net/ab7253957/article/details/72818289

shell 字符串转数组 数组转字典
https://blog.csdn.net/wojiuguowei/article/details/84402890
reference
