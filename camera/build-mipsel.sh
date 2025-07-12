#!/bin/bash

# 构建 mipsel-unknown-linux-gnu 目标的脚本

echo "正在为 mipsel-unknown-linux-gnu 构建 Rust 项目..."

# 确保目标目录存在并有适当的权限
mkdir -p target/mipsel-unknown-linux-gnu/debug
chmod 755 target/mipsel-unknown-linux-gnu/debug

# 使用 cross 构建，启用 build-std 功能
export RUSTFLAGS="-C target-feature=+crt-static"

# 切换到 camera 目录
cd camera

# 执行构建
cross build --target mipsel-unknown-linux-gnu -Z build-std=core,std,alloc,proc_macro

echo "构建完成！" 