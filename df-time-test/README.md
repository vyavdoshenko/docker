docker build --build-arg UID=$(id -u) -t df-test .

docker run --user builder --privileged -it --name df-test df-test /bin/bash

cd dragonfly

./helio/blaze.sh -release -DWITH_AWS:BOOL=OFF

cd build-opt

time ninja dragonfly

docker stop df-test && docker rm df-test