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
    build-essential \
    ca-certificates \
    curl \
    git \
    htop \
    iproute2 \
    iputils-ping \
    mc \
    neovim \
    netcat-openbsd \
    net-tools \
    software-properties-common \
    sudo \
    telnet \
    unzip \
    vim \
    wget \
    zsh

RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get update --fix-missing

RUN apt-get upgrade -y

RUN apt -y install \
    python3.11 \
    python3.11-dev \
    python3.11-tk \
    python3.11-venv \
    python3.11-distutils

# Add Docker repository and install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu jammy stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update --fix-missing && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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

RUN python3.11 -m venv /home/builder/.venv && \
    /home/builder/.venv/bin/pip install --upgrade pip setuptools wheel && \
    /home/builder/.venv/bin/pip install vectordb-bench

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

USER root

COPY zshrc /home/builder/.zshrc

WORKDIR /home/builder
