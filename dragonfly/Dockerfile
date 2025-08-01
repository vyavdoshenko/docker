FROM ubuntu:24.04

ARG UID
ARG GID

ENV LOCAL_UID=${UID}
ENV LOCAL_GID=${GID}

ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Kyiv

RUN apt-get update --fix-missing

RUN apt-get upgrade -y

RUN apt-get dist-upgrade -y

RUN apt-get install -y locales && localedef -i en_US -f UTF-8 en_US.UTF-8

# Generate Ukrainian locale
RUN localedef -i uk_UA -f UTF-8 uk_UA.UTF-8

ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8

RUN apt -y install \
    afl++ \
    autoconf \
    autoconf-archive \
    automake \
    bison \
    build-essential \
    ca-certificates \
    ccache \
    clang \
    clangd \
    cmake \
    curl \
    g++ \
    gdb \
    git \
    graphviz \
    htop \
    iproute2 \
    iputils-ping \
    libboost-all-dev \
    libboost-fiber-dev \
    libevent-dev \
    liblzma-dev \
    libre2-dev \
    libssl-dev \
    libssl-dev \
    libtool \
    libunwind-dev \
    libxml2-dev \
    libz-dev \
    libzstd-dev \
    lld \
    llvm \
    lsb-release \
    mc \
    mold \
    neovim \
    netcat-openbsd \
    net-tools \
    ninja-build \
    nodejs \
    npm \
    pkg-config \
    redis-tools \
    software-properties-common \
    sudo \
    telnet \
    tzdata\
    unzip \
    vim \
    wget \
    zlib1g-dev \
    zsh

RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get update --fix-missing

RUN apt-get upgrade -y

RUN apt -y install \
    python3.10 \
    python3.10-dev \
    python3.10-tk \
    python3.10-venv \
    python3.10-distutils

# Add memtier_benchmark
RUN curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/redis.list && \
    apt-get update --fix-missing && \
    apt-get install -y memtier-benchmark

# Add Docker repository and install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu jammy stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update --fix-missing && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add Helm repository and install Helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update --fix-missing && \
    apt-get install -y helm

# Install Go 1.24.1
RUN wget https://go.dev/dl/go1.24.1.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go1.24.1.linux-amd64.tar.gz && \
    rm go1.24.1.linux-amd64.tar.gz

# Install Redis 6.2.11
RUN wget http://download.redis.io/releases/redis-6.2.11.tar.gz && \
    tar xzf redis-6.2.11.tar.gz && \
    cd redis-6.2.11 && \
    make -j && \
    make PREFIX=/usr/local/redis-6.2.11 install && \
    ln -s /usr/local/redis-6.2.11/bin/redis-server /usr/local/bin/redis-server-6.2.11

# Install Redis 7.2.2
RUN wget http://download.redis.io/releases/redis-7.2.2.tar.gz && \
    tar xzf redis-7.2.2.tar.gz && \
    cd redis-7.2.2 && \
    make -j && \
    make PREFIX=/usr/local/redis-7.2.2 install && \
    ln -s /usr/local/redis-7.2.2/bin/redis-server /usr/local/bin/redis-server-7.2.2

# Install Valkey 8.0.1
RUN wget -O valkey-8.0.1.tar.gz https://github.com/valkey-io/valkey/archive/refs/tags/8.0.1.tar.gz && \
    tar xzf valkey-8.0.1.tar.gz && \
    cd valkey-8.0.1 && \
    make -j && \
    make PREFIX=/usr/local/valkey-8.0.1 install && \
    ln -s /usr/local/valkey-8.0.1/bin/valkey-server /usr/local/bin/valkey-server-8.0.1

ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/home/builder/go
ENV PATH=$PATH:$GOPATH/bin

RUN mkdir -p /etc/valkey && \
    cd /etc/valkey && \
    echo "[ req ]" > /etc/valkey/openssl.cnf && \
    echo "default_bits       = 2048" >> /etc/valkey/openssl.cnf && \
    echo "prompt             = no" >> /etc/valkey/openssl.cnf && \
    echo "default_md         = sha256" >> /etc/valkey/openssl.cnf && \
    echo "distinguished_name = req_distinguished_name" >> /etc/valkey/openssl.cnf && \
    echo "req_extensions     = req_ext" >> /etc/valkey/openssl.cnf && \
    echo "[ req_distinguished_name ]" >> /etc/valkey/openssl.cnf && \
    echo "C  = US" >> /etc/valkey/openssl.cnf && \
    echo "ST = Test" >> /etc/valkey/openssl.cnf && \
    echo "L  = Test" >> /etc/valkey/openssl.cnf && \
    echo "O  = Test" >> /etc/valkey/openssl.cnf && \
    echo "OU = Test" >> /etc/valkey/openssl.cnf && \
    echo "CN = localhost" >> /etc/valkey/openssl.cnf && \
    echo "[ req_ext ]" >> /etc/valkey/openssl.cnf && \
    echo "subjectAltName = @alt_names" >> /etc/valkey/openssl.cnf && \
    echo "[ alt_names ]" >> /etc/valkey/openssl.cnf && \
    echo "IP.1 = 127.0.0.1" >> /etc/valkey/openssl.cnf && \
    echo "IP.2 = ::1" >> /etc/valkey/openssl.cnf && \
    echo "IP.3 = deaf:b19:d00d::2" >> /etc/valkey/openssl.cnf && \
    echo "IP.4 = deaf:b19:d00d::3" >> /etc/valkey/openssl.cnf && \
    openssl genpkey -algorithm RSA -out /etc/valkey/ca.key -pkeyopt rsa_keygen_bits:2048 && \
    openssl req -key /etc/valkey/ca.key -new -x509 -out /etc/valkey/ca.crt -days 3650 -config /etc/valkey/openssl.cnf && \
    openssl genpkey -algorithm RSA -out /etc/valkey/server.key -pkeyopt rsa_keygen_bits:2048 && \
    openssl req -key /etc/valkey/server.key -new -out /etc/valkey/server.csr -config /etc/valkey/openssl.cnf && \
    openssl x509 -req -in /etc/valkey/server.csr -CA /etc/valkey/ca.crt -CAkey /etc/valkey/ca.key -CAcreateserial \
    -out /etc/valkey/server.crt -days 3650 -extfile /etc/valkey/openssl.cnf -extensions req_ext && \
    openssl genpkey -algorithm RSA -out /etc/valkey/client.key -pkeyopt rsa_keygen_bits:2048 && \
    openssl req -key /etc/valkey/client.key -new -out /etc/valkey/client.csr -config /etc/valkey/openssl.cnf && \
    openssl x509 -req -in /etc/valkey/client.csr -CA /etc/valkey/ca.crt -CAkey /etc/valkey/ca.key -CAcreateserial \
    -out /etc/valkey/client.crt -days 3650 -extfile /etc/valkey/openssl.cnf -extensions req_ext && \
    chmod 0644 *

RUN existing_user=$(getent passwd $LOCAL_UID | cut -d: -f1) && \
    if [ -n "$existing_user" ]; then \
        echo "Removing existing user: $existing_user with UID $LOCAL_UID"; \
        deluser --remove-home "$existing_user"; \
    fi && \
    if [ -n "$LOCAL_GID" ]; then \
        if ! getent group $LOCAL_GID > /dev/null; then \
            addgroup --gid $LOCAL_GID g${LOCAL_GID}; \
        fi; \
        adduser --uid $LOCAL_UID --gid $LOCAL_GID --gecos "" --disabled-password --home /home/builder --shell /usr/bin/zsh builder; \
    else \
        adduser --uid $LOCAL_UID --gecos "" --disabled-password --home /home/builder --shell /usr/bin/zsh builder; \
    fi

RUN usermod -aG sudo builder && echo "builder ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/builder

# Add builder to docker group
RUN usermod -aG docker builder

# Configure Docker to run without sudo
RUN mkdir -p /etc/docker && \
    echo '{\n  "live-restore": true,\n  "group": "docker"\n}' > /etc/docker/daemon.json

# Install Rust and Cargo for builder user
USER builder
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    . "$HOME/.cargo/env" && \
    cargo install fd-find eza ripgrep bat

RUN python3.10 -m venv /home/builder/.venv && \
    /home/builder/.venv/bin/pip install --upgrade pip setuptools wheel

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

RUN git clone https://github.com/dragonflydb/df-afl.git /home/builder/df-afl

USER root

COPY zshrc /home/builder/.zshrc

COPY colorize_script.py /home/builder/.colorize_script.py

WORKDIR /home/builder
