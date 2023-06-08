# docker files repository

How to build container:
``` sh
docker build -t builder .
```

How to start zsh inside container:
``` sh
docker run --mount type=bind,source=${HOME}/veego,destination=/root/veego -it --name builder-container builder /usr/bin/zsh
```
