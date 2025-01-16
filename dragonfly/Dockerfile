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
    libzstd-dev \
    bison \
    libxml2-dev \
    zlib1g-dev \
    redis-tools

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

ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/home/builder/go
ENV PATH=$PATH:$GOPATH/bin

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

RUN git config --global --add safe.directory ~/dragonfly/build/third_party/aws

COPY zshrc /home/builder/.zshrc

WORKDIR /home/builder