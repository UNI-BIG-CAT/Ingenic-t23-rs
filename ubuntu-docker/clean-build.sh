#!/bin/bash

echo "🧹 清理 Docker 环境并重新构建"
echo "================================"

# 停止并删除相关容器
echo "停止并删除现有容器..."
docker-compose down --remove-orphans

# 删除相关镜像
echo "删除旧的镜像..."
docker rmi -f ubuntu-docker_rust-mips 2>/dev/null || echo "没有找到旧镜像"

# 清理构建缓存
echo "清理构建缓存..."
docker builder prune -f

# 清理系统（可选）
read -p "是否清理整个 Docker 系统？(y/N): " clean_system
if [[ $clean_system =~ ^[Yy]$ ]]; then
    echo "清理 Docker 系统..."
    docker system prune -f
fi

echo ""
echo "🚀 开始构建..."
echo "==================="

# 使用 --no-cache 确保完全重新构建
docker-compose build --no-cache

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 构建成功！"
    echo "启动容器："
    echo "docker-compose up -d"
    echo ""
    echo "进入容器："
    echo "docker exec -it rust-mipsel-dev bash"
    echo ""
    echo "在容器中测试编译："
    echo "cd /workspace/camera && cargo build --target mips-unknown-linux-gnu"
else
    echo ""
    echo "❌ 构建失败！"
    echo "请检查错误信息"
fi 