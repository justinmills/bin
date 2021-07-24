#! /bin/bash

# Swiped from here: https://gist.github.com/OnlyInAmerica/9964456

profile=$1
access_key=$2

aws --profile $profile --output text iam list-users | \
    awk '{print $NF}' | \
    xargs -P10 -n1 aws --profile $profile --output text iam list-access-keys --user-name | grep $access_key
