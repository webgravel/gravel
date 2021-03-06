#!/bin/bash
while [ "$1" != "" ]; do
    if [ "$1" = '--dev' ]; then
        DEV=true
        shift
    else
        cd "$1"
        shift
    fi
done

DIR="$PWD"
getname() {
    python -c 'import yaml; print yaml.safe_load(open("Gravelfile"))["name"]'
}

NAME="$(getname)"
OUTPUT1="$DIR/.makepkg.unsigned.tar"
OUTPUT2="$DIR/$NAME.gravelpkg"

if [ "$DEV" = true ]; then
    DIR=$(mktemp -d)
    TMPLOC=$DIR
    cp -r . $DIR/dev
    cd $DIR/dev
    git add .
    git commit -am "temporary" >/dev/null
fi

git archive HEAD > "$OUTPUT1"
ok=$?

if [ "$DEV" = true ]; then
    rm -rf "$TMPLOC"
fi

if [ "$ok" != 0 ]; then
    exit $ok
fi

gpg --homedir=$HOME/.gravel/gpg -a --sign < "$OUTPUT1" > "$OUTPUT2"
rm "$OUTPUT1"
