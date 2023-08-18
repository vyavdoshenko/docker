# docker files repository

## How to build container:

``` sh
docker build --build-arg UID=$(id -u) -t builder .
```

``` sh
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker build --platform linux/arm64 --build-arg UID=$(id -u) -t builder .
```

## How to start zsh inside container:

``` sh
docker docker run --user builder --mount type=bind,source=${HOME}/veego,destination=/home/builder/veego -it --name builder-container builder /usr/bin/zsh
```

``` sh
docker stop builder-container && docker rm builder-container && docker run --user builder --mount type=bind,source=${HOME}/veego,destination=/home/builder/veego -it --name builder-container builder /usr/bin/zsh
```
