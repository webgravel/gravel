#!/bin/bash

cd "$(dirname $0)/.."

if [ ! -e ~/bin ]; then
    echo -n "Create $HOME/bin and add it to path? [Y] "
    read ans
    if [ "$ans" != n -a "$ans" != N ]; then
        mkdir ~/bin
        line='export PATH="$PATH:$HOME/bin"'
        echo $line >> ~/.bashrc
        if [ -e ~/.zshrc ]; then
            echo $line >> ~/.zshrc
        fi
    else
        exit
    fi
fi

ln -s $PWD/dev/launcher.sh ~/bin/graveldev
