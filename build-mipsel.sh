#!/bin/bash

# 构建 mipsel-unknown-linux-gnu 目标的脚本

echo "正在为 mipsel-unknown-linux-gnu 构建 Rust 项目..."

# 确保使用 nightly 版本
echo "设置 Rust 工具链为 nightly..."
rustup default nightly

# 确保目标目录存在并有适当的权限
mkdir -p camera/target/mipsel-unknown-linux-gnu/debug
chmod 755 camera/target/mipsel-unknown-linux-gnu/debug

# | Rust 版本     | 用途               | 特点                                                  |
# | ----------- | ---------------- | --------------------------------------------------- |
# | **stable**  | 正式发布的稳定版本        | 安全可靠，适合生产环境                                         |
# | **beta**    | 下一个 stable 的候选版本 | 用于测试稳定性                                             |
# | **nightly** | 每日构建，开发者使用       | 可以启用试验性功能，例如 `-Z build-std`、`generic_const_exprs` 等 |

# +nightly
# 指定使用 Rust nightly 工具链。
# 因为 -Z build-std=... 是 nightly-only unstable feature，必须加这个。

# --target mipsel-unknown-linux-gnu
# 指定交叉编译的目标平台为 MIPS 架构（小端字节序）、Linux 系统、GNU libc。
# 执行构建，使用 nightly 版本和 build-std

# -Z build-std=core,std,alloc,proc_macro
# -Z 表示调用一个 unstable 编译器功能（Z flag），只能在 nightly 下用。
# build-std=... 表示要自己 构建 Rust 标准库，而不是从官方预编译包下载。
# core,std,alloc,proc_macro 表示要构建的标准库模块。
cross +nightly build --target mipsel-unknown-linux-gnu -Z build-std=core,std,alloc,proc_macro

echo "构建完成！" 