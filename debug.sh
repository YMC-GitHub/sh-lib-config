
#!/bin/sh

THIS_FILE_PATH=$(cd `dirname $0`; pwd)
#echo $THIS_FILE_PATH
#$THIS_FILE_PATH/from-cli-args.sh --help
#$THIS_FILE_PATH/from-a-config-file.sh --help
# bash $THIS_FILE_PATH/from-a-config-file.sh
bash $THIS_FILE_PATH/from-a-config-file.sh --file=./a-config-file-2.txt 
#### 基础用法
:<<how-to-use-for-pro
#作为解释器参数
bash ./index.sh
#作为可执行程序
#2 切换到脚本所在目录
./index.sh 
#2 切换到其他目录执行
shell-get-config/index.sh
how-to-use-for-pro
