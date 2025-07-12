#!/bin/bash

# 构建 mipsel-unknown-linux-gnu 目标的脚本

echo "正在为 mipsel-unknown-linux-gnu 构建 Rust 项目..."

# 确保使用 nightly 版本
echo "设置 Rust 工具链为 nightly..."
rustup default nightly

# 确保目标目录存在并有适当的权限
mkdir -p camera/target/mipsel-unknown-linux-gnu/debug
chmod 755 camera/target/mipsel-unknown-linux-gnu/debug

# 执行构建，使用 nightly 版本和 build-std
cross +nightly build --target mipsel-unknown-linux-gnu -Z build-std=core,std,alloc,proc_macro

echo "构建完成！" 