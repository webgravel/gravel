#!/bin/bash
# Check if everything is commited, pulls and pushes.
cd "$(dirname $0)/.."
URL=git@github.com:webgravel
for repo in $(cat dev/repos.list); do
    cd $repo
    if ! git status | grep -q 'nothing to commit, working directory clean'; then
        echo "Warning: $repo not clean"
    fi
    cd ..
done

tmpdir=`mktemp -d`

exit_script() {
    rm -r $tmpdir
    kill $pid
}

trap exit_script EXIT

echo 'ssh -o ControlPath='$tmpdir'/sock "$@"' > $tmpdir/sshcmd
chmod +x $tmpdir/sshcmd
export GIT_SSH="$tmpdir/sshcmd"

ssh -o ControlPath=$tmpdir/sock -MN git@github.com & pid=$!

for repo in $(cat dev/repos.list); do
    cd $repo
    if git remote show origin -n | grep -q "https://github.com/webgravel/$repo"; then
        git remote set-url origin $URL/$repo
    fi
    git pull && git push || exit 1
    cd ..
done
