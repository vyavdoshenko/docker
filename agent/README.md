# docker files repository

## Start Jenkins
```
mkdir -p ${HOME}/jenkins_home
docker run -d -p 8080:8080 -p 50000:50000 --mount type=bind,source=${HOME}/jenkins_home,destination=/var/jenkins_home jenkins/jenkins:lts
```

## How to build container for agent:

``` sh
docker build --build-arg UID=$(id -u) -t jenkins-agent .
```


## How to start container:

``` sh
docker run --user builder -e JENKINS_URL=http://192.168.1.103:8080 -e JENKINS_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -e JENKINS_AGENT_NAME=builder -d jenkins-agent
```
