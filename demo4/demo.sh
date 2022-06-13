#!/bin/bash
set -e
prefix=$(dirname $(realpath $0))
# exec &>>$prefix/demo.log
echo "============================="
echo "工作目录 $PWD"
echo "用户身份 $(id)"
echo "脚本路径 $0, $(realpath $0)"
stress -t 3 -m 10 --vm-bytes 10240
echo "程序执行完毕"
echo "-----------------------------"


