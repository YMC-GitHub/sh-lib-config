#!/bin/sh

# 读取传入参数
# 需要：
# 设置参数规则
# 解析相关参数
# 更新相关变量
# 显示帮助信息


THIS_FILE_PATH=$(cd `dirname $0`; pwd)
source $THIS_FILE_PATH/path-resolve.sh

USAGE_MSG_PATH=${THIS_FILE_PATH}/help
# 帮助信息
HELP_DIR=$(path_resolve $THIS_FILE_PATH "../help")
USAGE_MSG_FILE=${HELP_DIR}/from-cli-args.txt

# 参数规则
GETOPT_ARGS_SHORT_RULE="-o h,s:,e::,n"
GETOPT_ARGS_LONG_RULE="--long help,sdate:,edate::,numprocs"

# 显示帮助信息
if [[ -z $@ ]]
then
    echo $USAGE_MSG
    exit 0
fi

# 设置参数规则
GETOPT_ARGS=`getopt $GETOPT_ARGS_SHORT_RULE \
$GETOPT_ARGS_LONG_RULE -- "$@"`
# 解析参数规则
eval set -- "$GETOPT_ARGS"

# 更新相关变量
while [ -n "$1" ]
do
    case $1 in
    -s|--sdate) #可选，参数必带取值
    sdate=$2
    shift 2
    ;;
    -e|--edate) #可选，参数可带取值
    edate=$2
    shift 2
    ;;
    -n|--numprocs) #可选，参数不带取值
    numprocs=true
    #numprocs=$2
    shift 2
    ;;
    -h|--help) #可选，不接参数
    cat $USAGE_MSG_FILE
    exit 1
    ;;
    --)
    break
    ;;
    *)
    cat $USAGE_MSG_FILE
    ;;
    esac
done

# 输出相关变量
echo $sdate,$edate,$numprocs
# 待办:
# 读取配置文件
# 更新相关变量

# 查看某文件的权限
:<<get-one-file-right
ONE_FILE=from-cli-args.sh
ls -l |grep "${ONE_FILE}" | cut --delimiter " " --fields 1
get-one-file-right


#### 参考文献
:<<reference
shell脚本传可选参数 getopts 和 getopt的方法
https://www.cnblogs.com/zhang-xiaoyu/p/9296217.html
reference

