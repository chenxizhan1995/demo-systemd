#!/bin/bash

declare -p PREFIX FULL_NAME SHELL PATH HOME

echo "工作目录 $PWD"
echo "用户身份 $(id)"

systemctl show  -p FragmentPath $FULL_NAME

echo 脚本路径 $0, $(realpath $0)
