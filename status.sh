#!/bin/bash
cd "$(dirname $0)/.."
. dev/common.sh
. dev/colors.sh

r() {
    if ! git status | grep -q 'nothing to commit, working directory clean'; then
        printf "# Repository $BYellow%s$Color_Off\n" "$repo"
        git status
    fi
}

foreach_repo r
