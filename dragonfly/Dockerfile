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
    net-tools

RUN adduser --uid $LOCAL_UID --gecos "" --disabled-password --home /home/builder --shell /usr/bin/zsh builder

RUN chmod 0777 /home/builder

RUN usermod -aG sudo builder && echo "builder ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/builder

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

RUN mv ~/.oh-my-zsh /home/builder

RUN git config --global --add safe.directory ~/dragonfly/build/third_party/aws

COPY zshrc /home/builder/.zshrc

WORKDIR /home/builder