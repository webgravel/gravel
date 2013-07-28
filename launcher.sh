#!/bin/bash
progname="$(readlink "$0")"
if [ "$progname" == "" ]; then
    progname="$0"
fi
dir="$(dirname "$progname")"

if [ $# = 0 ]; then
    cd "$dir"
    pre_scripts=*.sh

    for name in $pre_scripts; do
        if [ -e "$name" ]; then
            scripts="$scripts|$(basename $name .sh)"
        fi
    done
    echo "Usage: $0 ${scripts#'|'}"
else
    script="$1"
    shift
    "$dir/$script.sh" "$@"
fi
