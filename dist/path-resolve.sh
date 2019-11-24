#!/bin/sh

function path_resolve_for_relative(){
local str1="${1}"
local str2="${2}"
local slpit_char1=/
local slpit_char2=/
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
    elif [ $val2 = "." ]
    then
        echo "it is current file" > /dev/null 2>&1
    else
        index=$length
        arr1[$index]=$val2
        #echo ${arr1[*]}
    fi
done
# 路径-转为字符
local str3=''
for i in ${arr1[@]};do
  str3=$str3/$i;
done
if [ -z $str3 ] ; then str3="/"; fi
echo $str3
}
function path_resolve(){
local str1="${1}"
local str2="${2}"
local slpit_char1=/
local slpit_char2=/
if [[ -n ${3} ]]
then
    slpit_char1=${3}
fi
if [[ -n ${4} ]]
then
    slpit_char2=${4}
fi

#FIX:when passed asboult path,dose not return the asboult path itself
#str2="/d/"
local str3=""
str2=$(echo $str2 | sed "s#/\$##")
ABSOLUTE_PATH_REG_PATTERN="^/"
if [[ $str2 =~ $ABSOLUTE_PATH_REG_PATTERN ]] ; 
then 
    str3=$str2; 
else
    str3=$(path_resolve_for_relative $str1 $str2 $slpit_char1 $slpit_char2)
fi
echo $str3
}