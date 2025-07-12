#!/bin/bash

echo "🔍 Docker 构建测试脚本"
echo "====================="

# 检查 Docker 状态
echo "检查 Docker 状态..."
docker --version
docker-compose --version

echo ""
echo "选择测试方案："
echo "1. 最小化测试（仅基础 Rust 环境）"
echo "2. 完整构建（带 MIPS 交叉编译）"
echo "3. 清理重建（完全清理后构建）"
echo ""

read -p "请选择 (1-3): " choice

case $choice in
    1)
        echo "🧪 开始最小化测试..."
        docker build -f Dockerfile.minimal -t test-minimal .
        if [ $? -eq 0 ]; then
            echo "✅ 最小化构建成功！"
            echo "测试运行："
            docker run --rm test-minimal rustc --version
        else
            echo "❌ 最小化构建失败"
        fi
        ;;
    2)
        echo "🚀 开始完整构建..."
        docker-compose build
        if [ $? -eq 0 ]; then
            echo "✅ 完整构建成功！"
        else
            echo "❌ 完整构建失败"
        fi
        ;;
    3)
        echo "🧹 清理重建..."
        ./clean-build.sh
        ;;
    *)
        echo "无效选择"
        exit 1
        ;;
esac 