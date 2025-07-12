# 君正芯片 Rust 交叉编译环境

## 问题描述

在君正 MIPS 芯片上运行 Rust 程序时遇到错误：
```
./camera: line 2: syntax error: unexpected "("
```

## 问题原因

这是一个典型的交叉编译架构不匹配问题：

1. **架构不匹配**: 君正芯片使用 MIPS little endian (mipsel) 架构
2. **编译目标错误**: 之前配置使用的是 big endian (`mips-unknown-linux-gnu`)
3. **二进制文件架构错误**: 编译的程序无法在目标设备上运行

## 解决方案

### 1. 环境配置

已修正 Docker 配置文件，使用正确的目标架构：

- **目标架构**: `mipsel-unknown-linux-gnu` (little endian)
- **交叉编译器**: `mipsel-linux-gnu-gcc`
- **备选方案**: `mipsel-unknown-linux-musl` (静态链接，更好兼容性)

### 2. 构建步骤

#### 方法一：使用专用构建脚本

```bash
# 1. 构建 Docker 环境
docker-compose build

# 2. 启动容器
docker-compose up -d

# 3. 进入容器
docker exec -it rust-mipsel-dev bash

# 4. 运行君正芯片专用构建脚本
./build-for-ingenic.sh
```

#### 方法二：手动编译

```bash
# 在 Docker 容器中
cd /workspace/camera

# 设置环境变量
export CC_mipsel_unknown_linux_gnu=mipsel-linux-gnu-gcc
export CXX_mipsel_unknown_linux_gnu=mipsel-linux-gnu-g++
export AR_mipsel_unknown_linux_gnu=mipsel-linux-gnu-ar
export CARGO_TARGET_MIPSEL_UNKNOWN_LINUX_GNU_LINKER=mipsel-linux-gnu-gcc

# 编译（使用静态链接）
RUSTFLAGS="-C target-feature=+crt-static" cargo build --target mipsel-unknown-linux-gnu --release
```

### 3. 验证编译结果

```bash
# 检查二进制文件架构
file target/mipsel-unknown-linux-gnu/release/camera

# 预期输出应该包含:
# ELF 32-bit LSB executable, MIPS, MIPS32 rel2 processor
```

### 4. 部署到君正设备

```bash
# 1. 复制二进制文件到设备
scp target/mipsel-unknown-linux-gnu/release/camera user@device:/path/to/camera

# 2. 在设备上添加执行权限
chmod +x camera

# 3. 运行
./camera
```

## 故障排除

### 如果仍然遇到问题

1. **检查设备架构**:
   ```bash
   # 在君正设备上运行
   uname -m  # 应该显示 mips
   ldd --version  # 检查 glibc 版本
   ```

2. **使用 musl 目标**（推荐）:
   ```bash
   # 如果 glibc 版本太老，使用 musl 静态链接
   rustup target add mipsel-unknown-linux-musl
   cargo build --target mipsel-unknown-linux-musl --release
   ```

3. **检查依赖项**:
   ```bash
   # 确保所有依赖项都支持 MIPS 架构
   cargo tree
   ```

### 常见错误及解决方法

| 错误信息 | 原因 | 解决方法 |
|---------|------|----------|
| `syntax error: unexpected "("` | 架构不匹配 | 使用正确的 mipsel 目标编译 |
| `cannot execute binary file` | 二进制格式错误 | 确认使用 mipsel-unknown-linux-gnu |
| `version 'GLIBC_X.X' not found` | glibc 版本过老 | 使用 musl 目标或静态链接 |

## 技术详情

- **目标设备**: 君正芯片 (Linux Ingenic-g1_1 3.10.14)
- **架构**: MIPS little endian
- **编译环境**: Ubuntu 22.04 + Rust + mipsel-linux-gnu 工具链
- **推荐目标**: `mipsel-unknown-linux-musl`（最佳兼容性）

## 快速命令参考

```bash
# 清理并重新构建
./clean-build.sh

# 测试构建
./test-build.sh

# 专用君正芯片构建
./build-for-ingenic.sh
``` 