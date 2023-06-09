FROM ubuntu:22.04

ARG UID

ENV LOCAL_UID=${UID}

RUN apt-get update

RUN apt-get upgrade -y

RUN apt-get dist-upgrade -y

RUN apt-get install -y build-essential gcc g++ clang cmake git libc++-dev libc++1 libc++abi-dev libc++abi1 libssl-dev zsh neovim sudo curl wget ninja-build ripgrep exa bat mc

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

RUN usermod -aG sudo builder && echo "builder ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/builder

RUN su - builder -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

RUN su - builder -c 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'

RUN su - builder -c 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'

COPY zshrc /home/builder/.zshrc

WORKDIR /home/builder