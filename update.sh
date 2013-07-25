#!/bin/bash
cd "$(dirname $0)/.."
URL=https://github.com/webgravel
for repo in $(cat dev/repos.list); do
    if [ -e $repo ]; then
        (cd $repo; git pull) || exit 1
    else
        git clone $URL/$repo
    fi
done
