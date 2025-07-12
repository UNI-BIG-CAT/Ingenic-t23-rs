FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 配置国内软件源镜像
RUN sed -i 's@archive.ubuntu.com@mirrors.aliyun.com@g' /etc/apt/sources.list && \
    sed -i 's@security.ubuntu.com@mirrors.aliyun.com@g' /etc/apt/sources.list

# 环境变量：使用 rsproxy 镜像源（关键）
ENV RUSTUP_DIST_SERVER=https://rsproxy.cn
ENV RUSTUP_UPDATE_ROOT=https://rsproxy.cn/rustup

# 分步安装
RUN apt update && apt install -y \
    curl \
    ca-certificates \
    build-essential \
    gcc-mipsel-linux-gnu \
    g++-mipsel-linux-gnu \
    pkg-config \
    git \
    vim \
    nano \
    python3 \
    python3-pip \
    file \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 安装 Rust（minimal 安装）
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal
ENV PATH="/root/.cargo/bin:${PATH}"

# 验证安装
RUN rustc --version && cargo --version

# 设置代理
ENV https_proxy=http://host.docker.internal:7897
ENV http_proxy=http://host.docker.internal:7897
# ENV no_proxy=localhost,127.0.0.1

# 安装 cross
RUN cargo install cross --git https://github.com/cross-rs/cross
# 添加 MIPS little endian 目标（君正用的是 mipsel）
# RUN rustup target add mipsel-unknown-linux-gnu

# 可选：musl 支持
# RUN rustup target add mipsel-unknown-linux-musl || echo "musl 目标暂时不可用"

# 配置默认交叉编译 linker
# RUN mkdir -p /root/.cargo && echo '[target.mipsel-unknown-linux-gnu]\nlinker = "mipsel-linux-gnu-gcc"' > /root/.cargo/config.toml

# 工作目录
WORKDIR /workspace

CMD ["/bin/bash"]
