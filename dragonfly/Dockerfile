FROM ghcr.io/romange/ubuntu-dev:22

ARG UID

ENV LOCAL_UID=${UID}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get upgrade -y

RUN apt-get dist-upgrade -y

RUN apt-get install -y locales && localedef -i en_US -f UTF-8 en_US.UTF-8

ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8

RUN apt -y install \
    git \
    wget \
    unzip \
    curl \
    zsh \
    neovim \
    sudo \
    ripgrep \
    bat \
    mc \
    fd-find \
    exa \
    net-tools \
    ninja-build \
    libunwind-dev \
    libboost-fiber-dev \
    libssl-dev \
    autoconf-archive \
    libtool \
    cmake \
    g++ \
    pkg-config \
    libzstd-dev \
    bison \
    libxml2-dev \
    zlib1g-dev \
    libre2-dev \
    redis-tools \
    iputils-ping \
    net-tools \
    telnet \
    iproute2

# Add Docker repository and install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu jammy stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add Helm repository and install Helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && \
    apt-get install -y helm

# Install Go 1.19
RUN wget https://go.dev/dl/go1.19.13.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go1.19.13.linux-amd64.tar.gz && \
    rm go1.19.13.linux-amd64.tar.gz

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
    echo "CN = ::1" >> /etc/valkey/openssl.cnf && \
    echo "[ req_ext ]" >> /etc/valkey/openssl.cnf && \
    echo "subjectAltName = @alt_names" >> /etc/valkey/openssl.cnf && \
    echo "[ alt_names ]" >> /etc/valkey/openssl.cnf && \
    echo "IP.1 = 127.0.0.1" >> /etc/valkey/openssl.cnf && \
    echo "IP.2 = ::1" >> /etc/valkey/openssl.cnf && \
    echo "IP.3 = fd00:dead:beef::2" >> /etc/valkey/openssl.cnf && \
    echo "IP.4 = fd00:dead:beef::3" >> /etc/valkey/openssl.cnf && \
    openssl req -x509 -new -nodes -keyout redis.ca.key -out redis.ca.pem -days 365 \
    -subj "/C=US/ST=Test/L=Test/O=Test/OU=Test/CN=Redis Test CA" && \
    openssl req -new -nodes -keyout redis.server.key -out redis.server.csr -config openssl.cnf && \
    openssl x509 -req -in redis.server.csr -CA redis.ca.pem -CAkey redis.ca.key -CAcreateserial \
    -out redis.server.pem -days 365 -extensions req_ext -extfile openssl.cnf && \
    chmod 0644 * && \
    openssl x509 -in redis.server.pem -text -noout | grep "Subject Alternative Name" -A 1

RUN adduser --uid $LOCAL_UID --gecos "" --disabled-password --home /home/builder --shell /usr/bin/zsh builder

RUN chmod 0777 /home/builder

RUN usermod -aG sudo builder && echo "builder ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/builder

# Add builder to docker group
RUN usermod -aG docker builder

# Configure Docker to run without sudo
RUN mkdir -p /etc/docker && \
    echo '{\n  "live-restore": true,\n  "group": "docker"\n}' > /etc/docker/daemon.json

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

RUN mv ~/.oh-my-zsh /home/builder

COPY zshrc /home/builder/.zshrc

WORKDIR /home/builder