# docker files repository

## How to build container:

``` sh
docker build --build-arg UID=$(id -u) -t builder .
```


## How to start zsh inside container:

``` sh
docker docker run --user builder --mount type=bind,source=${HOME}/veego,destination=/home/builder/veego -it --name builder-container builder /bin/sh -c '/usr/bin/sudo /usr/bin/chown -hR builder /home/builder > /dev/null && /usr/bin/zsh'
```

``` sh
docker stop builder-container && docker rm builder-container && docker run --user builder --mount type=bind,source=${HOME}/veego,destination=/home/builder/veego -it --name builder-container builder /bin/sh -c '/usr/bin/sudo /usr/bin/chown -hR builder /home/builder > /dev/null && /usr/bin/zsh'
```
