#!/bin/bash

echo "🚀 为君正芯片构建 Rust 项目"
echo "========================="

# 检查是否在 Docker 容器中
if [ ! -f /.dockerenv ]; then
    echo "❌ 请在 Docker 容器中运行此脚本"
    echo "使用命令: docker-compose up -d && docker exec -it rust-mipsel-dev bash"
    exit 1
fi

# 进入项目目录
cd /workspace/camera

echo "🔍 检查 Rust 环境..."
rustc --version
cargo --version

echo ""
echo "🔍 检查可用的目标平台..."
rustup target list --installed | grep mips

echo ""
echo "🔍 检查交叉编译工具..."
which mipsel-linux-gnu-gcc
mipsel-linux-gnu-gcc --version

echo ""
echo "🚀 开始为君正芯片 (mipsel) 编译..."
echo "目标: mipsel-unknown-linux-gnu"
echo "================================"

# 设置环境变量
export CC_mipsel_unknown_linux_gnu=mipsel-linux-gnu-gcc
export CXX_mipsel_unknown_linux_gnu=mipsel-linux-gnu-g++
export AR_mipsel_unknown_linux_gnu=mipsel-linux-gnu-ar
export CARGO_TARGET_MIPSEL_UNKNOWN_LINUX_GNU_LINKER=mipsel-linux-gnu-gcc

# 编译选项
RUSTFLAGS="-C target-feature=+crt-static" cargo build --target mipsel-unknown-linux-gnu --release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 编译成功！"
    echo "二进制文件位置: target/mipsel-unknown-linux-gnu/release/camera"
    echo ""
    echo "🔍 验证编译结果..."
    file target/mipsel-unknown-linux-gnu/release/camera
    echo ""
    echo "📝 部署说明:"
    echo "1. 将 target/mipsel-unknown-linux-gnu/release/camera 复制到君正设备"
    echo "2. 在设备上添加执行权限: chmod +x camera"
    echo "3. 运行: ./camera"
    echo ""
    echo "⚠️  注意事项:"
    echo "- 如果仍有问题，可能需要静态链接 musl"
    echo "- 君正设备的 glibc 版本可能较老，建议使用 musl 目标"
else
    echo ""
    echo "❌ 编译失败！"
    echo ""
    echo "🔧 可能的解决方案:"
    echo "1. 尝试使用 musl 目标: rustup target add mipsel-unknown-linux-musl"
    echo "2. 检查依赖项是否支持 MIPS 架构"
    echo "3. 使用静态链接: RUSTFLAGS='-C target-feature=+crt-static'"
fi 