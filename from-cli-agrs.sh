#!/bin/sh

# 读取传入参数
# 需要：
# 设置参数规则
# 解析相关参数
# 更新相关变量
# 显示帮助信息

# 文件路径
FILE_PATH=$(cd `dirname $0`; pwd)
# 帮助信息
USAGE_MSG="args:[-s,-e,-n,-c]\
[--sdate,--edate,-numprocs,--cfile]"
# 参数规则
GETOPT_ARGS_SHORT_RULE="-o s:e:n:c"
GETOPT_ARGS_LONG_RULE="--long sdate:,edate:,numprocs:,cfile:"

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
    -s|--sdate)
    sdate=$2
    shift 2
    ;;
    -e|--edate)
    edate=$2
    shift 2
    ;;
    -n|--numprocs)
    numprocs=$2
    shift 2
    ;;
    -c|--cfile)
    cfile=$2
    shift 2
    ;;
    --)
    break
    ;;
    *)
    echo $USAGE_MSG
    ;;
    esac
done

# 输出相关变量
echo $sdate,$cfile

#### 参考文献
:<<reference

reference

#### 基础用法
:<<how-to-use-for-pro
bash ./from-cli-agrs.sh
bash ./from-cli-agrs.sh -s hi
bash ./from-cli-agrs.sh -s hi --cfile yemiancheng
how-to-use-for-pro