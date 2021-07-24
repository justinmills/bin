#! /bin/bash

# Script to simulate building a docker image like jenkins does

DIR=${PWD##*/}

FILE=DockerfileJenkins
if [ ! -f $FILE ] ; then
    FILE=Dockerfile
fi
if [ ! -f $FILE ] ; then
    >&2 echo "Can't find dockerfile"
    exit 1
fi

docker build -t "${DIR}-jenkins" --build-arg "MYGET_USER=$MYGET_USER" --build-arg "MYGET_PASS=$MYGET_PASS" -f $FILE .
