# to be done
# syntax=docker/dockerfile:1

### Create

## remote
FROM ubuntu:22.04 AS slurm

RUN apt update
RUN apt-get -y install munge


RUN apt-get -y install vim less iputils-ping telnet
RUN apt-get -y install slurmdbd 
# slurm-client slurmd slurmctld  slurmrestd
### Configure

# copy munge in proper location

COPY slurmdbd.conf /etc/slurm/slurmdbd.conf
COPY munge.key /etc/munge/munge.key
COPY start.sh /root/start.sh
#RUN chmod 700 /root/configure.sh
#RUN chmod 700 /root/start.sh

CMD /root/start.sh

##
# docker pull registry
# docker container run -d -p 5000:5000 --name simple_registry registry
# docker image tag nginx:latest 127.0.0.1:5000/nginx:latest
# docker image push 127.0.0.1:5000/nginx:latest
## on all k8s nodes
# cat daemon.json w /etc/docker/daemon.json
# {
#  “insecure-registries” : [“adress registry:5000”]
# }

##

##
##!/bin/bash

##KEY_SIZE="2048"

##dd if=/dev/urandom bs=1 count=${KEY_SIZE} > munge.key
##chown munge: /etc/munge/munge.key
##chmod 400 /etc/munge/munge.key


# copy /etc/munge/munge.key to container
# copy slurmdbd.conf
# service munge status/start 


# docker exec -it bdba0f3a54d7 /bin/bash
# docker container run -it ubuntu:22.04 /bin/bash
