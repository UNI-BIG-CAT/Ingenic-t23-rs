# Ingenic-t23 - MIPS 交叉编译项目

本项目演示了如何为 MIPS 架构的嵌入式设备（如 Ingenic 设备）交叉编译 Rust 程序。

## 📁 项目结构

```
camera-rs-code/
├── camera/                          # 主要的 Rust 项目
│   ├── Cargo.toml                   # 项目配置文件
│   ├── Cargo.lock                   # 依赖锁定文件
│   ├── Cross.toml                   # Cross 交叉编译配置
│   ├── build-mipsel.sh              # 构建脚本
│   ├── src/
│   │   └── main.rs                  # 主程序入口
│   └── target/
│       └── mipsel-unknown-linux-gnu/
│           └── release/
│               └── camera           # 最终可执行文件
├── ubuntu-docker/                   # Docker 相关文件
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── ...
└── README.md                        # 项目说明文档
```

## 🔧 环境要求

### 必需工具

- **Rust** (nightly 版本)
- **Cross** 交叉编译工具
- **Docker** (Cross 工具依赖)

### 目标架构

- **mipsel-unknown-linux-gnu** - MIPS 小端序 Linux 目标

## ⚙️ 配置文件

### camera/Cargo.toml

```toml
[package]
name = "camera"
version = "0.1.0"
edition = "2021"

[profile.release]
lto = true

[dependencies]
```

### camera/Cross.toml

```toml
[build]
default-target = "mipsel-unknown-linux-gnu"

[target.mipsel-unknown-linux-gnu]
build-std = ["core", "std", "alloc", "proc_macro"]
```

## 🚀 编译步骤

### 1. 环境准备

```bash
# 安装 nightly 工具链
rustup toolchain install nightly
rustup default nightly

# 确保有 rust-src 组件
rustup component add rust-src

# 安装 cross 工具
cargo install cross
# 或者
cargo install cross --git https://github.com/cross-rs/cross
```

### 2. 执行编译

```bash
# 设置静态链接环境变量
export RUSTFLAGS="-C target-feature=+crt-static"

# 切换到项目目录
cd camera

# 执行交叉编译
cross +nightly build --target mipsel-unknown-linux-gnu -Z build-std=core,std,alloc --release
```

### 3. 使用构建脚本

```bash
# 给脚本执行权限
chmod +x build-mipsel.sh

# 运行构建脚本
./build-mipsel.sh
```

## 🔍 常见问题及解决方案

### 1. 权限问题

**错误**: `Permission denied (os error 13)`

**解决方案**: 确保目标目录有正确的权限
```bash
mkdir -p camera/target/mipsel-unknown-linux-gnu/debug
chmod 755 camera/target/mipsel-unknown-linux-gnu/debug
```

### 2. GLIBC 版本不匹配

**错误**: `version 'GLIBC_2.28' not found`

**解决方案**: 使用静态链接
```bash
export RUSTFLAGS="-C target-feature=+crt-static"
```

### 3. 标准库缺失

**错误**: `no rust-std component available for mipsel-unknown-linux-gnu`

**解决方案**: 使用 nightly 版本和 build-std 功能
```bash
cross +nightly build --target mipsel-unknown-linux-gnu -Z build-std=core,std,alloc
```

### 4. panic_abort 找不到

**错误**: `can't find crate for 'panic_abort'`

**解决方案**: 移除 Cargo.toml 中的 `panic = "abort"` 设置

## 📊 编译结果

### 可执行文件位置

```
camera/target/mipsel-unknown-linux-gnu/release/camera
```

### 文件特点

- **架构**: MIPS 小端序
- **链接**: 静态链接 (使用 +crt-static)
- **优化**: Release 版本，启用 LTO
- **目标设备**: Ingenic 嵌入式设备

### 部署到目标设备

```bash
# 复制到测试目录
cp camera/target/mipsel-unknown-linux-gnu/release/camera ./camera-rs-test

# 传输到目标设备
scp camera-rs-test user@device:/tmp/

# 在目标设备上运行
ssh user@device
cd /tmp
chmod +x camera-rs-test
./camera-rs-test
```

## 🛠️ 开发提示

1. **必须使用 nightly 版本**：mipsel 目标需要 build-std 功能
2. **启用静态链接**：避免 GLIBC 版本依赖问题
3. **构建组件限制**：只能使用 core, std, alloc, proc_macro
4. **Docker 依赖**：确保 Docker 运行，Cross 工具需要它

## 📝 版本信息

- **Rust Edition**: 2021
- **工具链**: nightly
- **交叉编译工具**: cross
- **目标架构**: mipsel-unknown-linux-gnu

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目。

## 📄 许可证

本项目采用 MIT 许可证。 