FROM fedora:30

# Fedora 30 is EOL, use archive mirrors
RUN sed -i 's|^metalink=|#metalink=|g' /etc/yum.repos.d/*.repo && \
    sed -i 's|^#baseurl=http://download.fedoraproject.org/pub/fedora/linux|baseurl=https://archives.fedoraproject.org/pub/archive/fedora/linux|g' /etc/yum.repos.d/*.repo

# Install build dependencies
RUN dnf install -y \
    gcc gcc-c++ make cmake ninja-build \
    gmp-devel mpfr-devel libmpc-devel \
    flex bison texinfo \
    curl tar xz bzip2 \
    git diffutils file which patch \
    boost-devel \
    && dnf clean all

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
RUN dnf install -y \
    openssl-devel boost-devel libunwind-devel \
    autoconf automake libtool \
    && dnf clean all

# Verify
RUN gcc --version && g++ --version
