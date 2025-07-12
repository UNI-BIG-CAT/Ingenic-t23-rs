# MIPS 交叉编译环境

这个配置提供了在 Docker 容器中进行 MIPS 架构 Rust 交叉编译的环境。

## 常见问题

### 错误代码 137 (SIGKILL)
如果遇到 `The command '/bin/sh -c curl https://sh.rustup.rs -sSf | sh -s -- -y' returned a non-zero code: 137` 错误，这通常是由于：

1. **内存不足** - Docker 构建过程中内存耗尽
2. **网络问题** - 下载 Rust 安装包失败
3. **构建超时** - 构建过程超时被终止

### 解决方案

#### 方案 1：使用测试脚本（推荐）
```bash
./test-build.sh
```
选择 "1" 进行最小化测试，如果成功再尝试完整构建。

#### 方案 2：清理重建
```bash
./clean-build.sh
```

#### 方案 3：手动故障排除
```bash
# 清理所有相关资源
docker-compose down --remove-orphans
docker rmi -f ubuntu-docker_rust-mips
docker builder prune -f

# 重新构建
docker-compose build --no-cache
```

## 使用方法

### 快速开始
```bash
# 测试构建
./test-build.sh

# 如果测试成功，启动容器
docker-compose up -d
docker exec -it rust-mipsel-dev bash
```

### 手动构建和运行
```bash
docker-compose build
docker-compose up -d
docker exec -it rust-mipsel-dev bash

# 在容器中编译
cd /workspace/camera
cargo build --target mips-unknown-linux-gnu
```

## 目录挂载

需要在 docker-compose.yml 中设置 `VOLUME_PATH` 环境变量：

```bash
export VOLUME_PATH=/d/code/camera_rs
# 或者在 .env 文件中设置
echo "VOLUME_PATH=/d/code/camera_rs" > .env
```

## 验证编译结果

在容器中编译后，可以使用 `file` 命令检查生成的二进制文件：

```bash
file target/mips-unknown-linux-gnu/debug/camera
```

应该显示 MIPS 架构的二进制文件。

## 故障排除

### 构建失败
1. 使用 `./test-build.sh` 进行分步测试
2. 检查 Docker 内存配置
3. 确保网络连接正常
4. 使用 `./clean-build.sh` 清理重建

### 内存不足
- 关闭其他占用内存的应用
- 增加 Docker 的内存限制
- 使用 `Dockerfile.minimal` 进行最小化构建

### 网络问题
- 检查防火墙设置
- 尝试使用不同的网络
- 考虑使用镜像加速器

## 配置文件说明

- `Dockerfile` - 主要的构建文件
- `Dockerfile.minimal` - 最小化测试用的构建文件
- `docker-compose.yml` - 容器编排配置
- `.env` - 环境变量配置
- `clean-build.sh` - 清理重建脚本
- `test-build.sh` - 分步测试脚本 