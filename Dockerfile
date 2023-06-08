FROM ubuntu:22.04

RUN apt-get update

RUN apt-get upgrade -y

RUN apt-get dist-upgrade -y

RUN apt-get install -y build-essential gcc g++ clang cmake git libc++-dev libc++1 libc++abi-dev libc++abi1 libssl-dev zsh

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
