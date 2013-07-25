#!/bin/bash

cd "$(dirname $0)"

if [ -e .begin ]; then
    echo "Already began."
    exit 1
fi

mkdir dev
mv *.sh *.list dev
mv .git .gitignore dev
cd dev
touch .began
./update.sh
