#!/bin/bash
GHOME=$(dirname "$0")/..
REPO_SRV=${REPO_SRV-gravelrepo@v0.atomshare.net}
REPO_PATH=${REPO_PATH-/home/gravelrepo/}

packages=$GHOME/*/Gravelfile
tmp=`mktemp -d`
trap "rm -r $tmp" EXIT

if [ "$1" = '--dev' ]; then
    DEV=--dev
else
    for pkg in $packages; do
        (
            cd $(dirname $pkg)
            if ! git status | grep -q 'nothing to commit..working directory clean'; then
                echo "Warning: uncommited changes in $(basename $(dirname $pkg)) (use --dev to package them)"
            fi
        )
    done
fi

# create packages in parallel (10 threads)
for pkg in $packages; do
    echo $(dirname $pkg)
done | xargs --max-args=1 -P 10 $GHOME/dev/makepkg.sh $DEV

for pkg in $packages; do
    cp -a $(dirname $pkg)/*.gravelpkg $tmp/
done

# transfer them to repo
# use ssh master socket to speed it up
rsync -r $tmp/ $REPO_SRV:$REPO_PATH
ssh $REPO_SRV chmod 644 $REPO_PATH'/*.gravelpkg'
