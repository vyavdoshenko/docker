# docker files repository

How to build container:
``` sh
docker build --build-arg UID=$(id -u) -t builder .
```

How to start zsh inside container:
``` sh
docker run --user builder --mount type=bind,source=${HOME}/veego,destination=/home/builder/veego -it --name builder-container builder /usr/bin/zsh
```
