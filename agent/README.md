# docker files repository

## How to build container:

``` sh
docker build --build-arg UID=$(id -u) -t jenkins-agent .
```


## How to start container:

``` sh
docker run -d -e JENKINS_URL=http://192.168.1.103:8080 -e JENKINS_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -e JENKINS_AGENT_NAME=builder jenkins-agent
```

