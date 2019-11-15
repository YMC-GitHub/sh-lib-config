#!/bin/sh

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