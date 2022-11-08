#!/bin/bash

INTEGRATION_BRANCH=$1

if [ -z "$1" ]
  then
    INTEGRATION_BRANCH="master"
fi

REMOTE="origin/$(echo $INTEGRATION_BRANCH)"

git branch --merged $(echo $REMOTE) | grep -v $(echo $INTEGRATION_BRANCH) | xargs git branch -d
