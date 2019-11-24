#!/bin/sh

# 缓存管理器
# 特性：
# 读取键名
# 读取键值
# 设置前缀

source ./dist/cache.sh
source ./dist/parse-passed-arg.sh
cache_read_built_in_config 
echo ${dic[*]}
echo ${!dic[*]}
cache_read_custom_config 

cache_get_val_by_key "k8s-worker-4"
cache_get_val_by_key "custom-file"
cache_get_val_by_key "k8s-worker-7"
#./test/test-cache.sh --custom-file a-config-file-2.txt


