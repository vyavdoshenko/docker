FROM ubuntu:20.04

ARG UID

ENV LOCAL_UID=${UID}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get upgrade -y

RUN apt-get dist-upgrade -y

RUN apt -y install \
    git \
    wget \
    xz-utils \
    flex \
    bison \
    libboost-dev \
    python3 \
    unzip \
    gcc \
    g++ \
    libncurses5-dev \
    libncursesw5-dev \
    libncurses-dev \
    gawk \
    xutils-dev \
    build-essential \
    libssl-dev \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    curl \
    clang \
    libc++-dev \
    libc++1 \
    libc++abi-dev \
    libc++abi1 \
    zsh \
    neovim \
    sudo \
    wget \
    ninja-build \
    ripgrep \
    bat \
    mc \
    lld \
    cpio \
    rsync \
    bc \
    fd-find

RUN cd /root && \
    if [ "$(uname -m)" = "x86_64" ]; then \
        wget -c http://old-releases.ubuntu.com/ubuntu/pool/universe/r/rust-exa/exa_0.9.0-4_amd64.deb --output-document exa_0.9.0-4.deb; \
    else \
        wget -c http://old-releases.ubuntu.com/ubuntu/pool/universe/r/rust-exa/exa_0.9.0-4_arm64.deb --output-document exa_0.9.0-4.deb; \
    fi && \
    apt-get -y install ./exa_0.9.0-4.deb

RUN mkdir cmake_install && \
    cd cmake_install && \
    wget https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4-linux-"$(uname -m)".sh --output-document cmake-3.26.4-linux.sh && \
    mkdir /opt/cmake && \
    sh cmake-3.26.4-linux.sh --skip-license --prefix=/opt/cmake && \
    ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake && \
    cmake --version

RUN cd /root && \
    git clone https://github.com/protocolbuffers/protobuf.git && \
    cd protobuf && \
    git fetch --all --tags && \
    git checkout tags/v3.21.2 -b v3.21.2-branch && \
    git submodule update --init --recursive && \
    mkdir -p build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j && \
    make install

RUN adduser --uid $LOCAL_UID --gecos "" --disabled-password --home /home/builder --shell /usr/bin/zsh builder

RUN chmod 0777 /home/builder

RUN usermod -aG sudo builder && echo "builder ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/builder

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

RUN mv ~/.oh-my-zsh /home/builder

COPY zshrc /home/builder/.zshrc

WORKDIR /home/builder