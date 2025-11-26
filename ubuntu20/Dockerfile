FROM ubuntu:20.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \
    gcc g++ make cmake ninja-build \
    libgmp-dev libmpfr-dev libmpc-dev \
    flex bison texinfo \
    curl tar xz-utils bzip2 \
    git diffutils file patch \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Build GCC 14
WORKDIR /tmp
RUN curl -LO https://ftp.gnu.org/gnu/gcc/gcc-14.3.0/gcc-14.3.0.tar.xz && \
    tar xf gcc-14.3.0.tar.xz && \
    cd gcc-14.3.0 && \
    mkdir build && cd build && \
    ../configure \
        --prefix=/opt/gcc-14 \
        --enable-languages=c,c++ \
        --disable-multilib \
        --disable-bootstrap && \
    make -j$(nproc) && \
    make install && \
    cd /tmp && rm -rf gcc-14.3.0*

# Set GCC 14 as default
ENV PATH="/opt/gcc-14/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/gcc-14/lib64:$LD_LIBRARY_PATH"
ENV CC=gcc
ENV CXX=g++

# Install other build dependencies for dragonfly
RUN apt-get update && apt-get install -y \
    libssl-dev libunwind-dev \
    autoconf automake libtool \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Build Boost with cmake config files
ARG BOOST_VERSION=1.85.0
ARG BOOST_VERSION_UNDERSCORE=1_85_0
WORKDIR /tmp/boost-build
RUN curl -L -o boost.tar.gz "https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}/boost-${BOOST_VERSION}-cmake.tar.gz" && \
    tar xzf boost.tar.gz && \
    cd boost-${BOOST_VERSION} && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=OFF && \
    cmake --build . -j$(nproc) && \
    cmake --install . && \
    cd /tmp && rm -rf /tmp/boost-build

# Build newer bison (Ubuntu 20.04 has 3.5.1, but let's use same version for consistency)
ARG BISON_VERSION=3.8.2
WORKDIR /tmp/bison-build
RUN curl -L -o bison.tar.xz "https://ftp.gnu.org/gnu/bison/bison-${BISON_VERSION}.tar.xz" && \
    tar xf bison.tar.xz && \
    cd bison-${BISON_VERSION} && \
    ./configure --prefix=/usr/local && \
    make -j$(nproc) && \
    make install && \
    cd /tmp && rm -rf /tmp/bison-build

# Make sure /usr/local/bin is in PATH
ENV PATH="/usr/local/bin:$PATH"

WORKDIR /build

# Verify
RUN gcc --version && g++ --version