FROM ubuntu:22.04

# 设置非交互模式，避免安装卡住
ENV DEBIAN_FRONTEND=noninteractive

# 配置国内软件源镜像
RUN sed -i 's@archive.ubuntu.com@mirrors.aliyun.com@g' /etc/apt/sources.list && \
    sed -i 's@security.ubuntu.com@mirrors.aliyun.com@g' /etc/apt/sources.list

# 分步安装，减少单次内存使用
RUN apt update && apt install -y \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN apt update && apt install -y \
    build-essential \
    gcc-mipsel-linux-gnu \
    g++-mipsel-linux-gnu \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN apt update && apt install -y \
    git \
    vim \
    nano \
    python3 \
    python3-pip \
    file \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 安装 Rust（使用更稳定的方式）
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal
ENV PATH="/root/.cargo/bin:${PATH}"

# 验证安装
RUN rustc --version && cargo --version

# 尝试添加 MIPS 目标（如果失败会继续）
RUN rustup target add mips-unknown-linux-gnu || echo "无法添加 mips-unknown-linux-gnu 目标"

# 配置默认交叉编译 linker
RUN mkdir -p /root/.cargo && echo '[target.mips-unknown-linux-gnu]\nlinker = "mips-linux-gnu-gcc"' > /root/.cargo/config.toml

# 工作目录
WORKDIR /workspace

CMD ["/bin/bash"]
