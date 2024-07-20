# Dragonfly builder container

## How to build container:

``` sh
docker build --build-arg UID=$(id -u) -t builder .
```

``` sh
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker build --platform linux/arm64 --build-arg UID=$(id -u) -t builder .
```

## How to start zsh inside container:

First time:
``` sh
docker docker run --user builder --mount type=bind,source=${HOME}/dragonfly,destination=/home/builder/dragonfly -it --name builder-container builder /usr/bin/zsh
```

Restart:
``` sh
docker stop builder-container && docker rm builder-container && docker run --user builder --mount type=bind,source=${HOME}/dragonfly,destination=/home/builder/dragonfly -it --name builder-container builder /usr/bin/zsh
```
