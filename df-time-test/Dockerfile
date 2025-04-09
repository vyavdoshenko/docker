FROM ghcr.io/romange/ubuntu-dev:22

ARG UID

ENV LOCAL_UID=${UID}

ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Kyiv

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
    sudo \
    ninja-build \
    libunwind-dev \
    libboost-context-dev \
    libssl-dev \
    autoconf-archive \
    libtool \
    cmake \
    g++ \
    bison \
    zlib1g-dev

RUN adduser --uid $LOCAL_UID --gecos "" --disabled-password --home /home/builder --shell /bin/bash builder

RUN chmod 0777 /home/builder

RUN usermod -aG sudo builder && echo "builder ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/builder

RUN git clone --recursive https://github.com/dragonflydb/dragonfly

RUN cd dragonfly && \
    git checkout v1.28.1 && \
    git submodule update --init --recursive && \
    cd .. && \
    mv dragonfly /home/builder/

RUN chown -hR builder /home/builder/dragonfly

WORKDIR /home/builder