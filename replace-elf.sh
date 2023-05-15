#!/bin/bash

LD="$1"
LIBC="$2"
BINARY="$3"

# 检查参数是否为空
if [ -z "$LD" ] || [ -z "$LIBC" ] || [ -z "$BINARY" ]; then
  echo "错误：缺少参数。请提供Libc-LD、Libc和二进制文件的路径。"
  echo "如："
  echo "replace-elf ld-2.23 libc-2.23.so pwn"
  exit 1
fi

# 检查解释器是否存在
if [ ! -e "$LD" ]; then
  echo "错误：Libc-LD文件不存在。"
  exit 1
fi

# 检查libc文件是否存在
if [ ! -e "$LIBC" ]; then
  echo "错误：libc文件不存在。"
  exit 1
fi

# 检查二进制文件是否存在
if [ ! -e "$BINARY" ]; then
  echo "错误：二进制文件不存在。"
  exit 1
fi

# 设置新的解释器
patchelf --set-interpreter "$LD" "$BINARY"

if [ $? -ne 0 ]; then
  echo "错误：设置解释器失败。"
  exit 1
fi

# 替换libc库
patchelf --replace-needed libc.so.6 "$LIBC" "$BINARY"

if [ $? -ne 0 ]; then
  echo "错误：替换Libc库失败。"
  exit 1
fi

echo "操作成功完成。"
