
foreach_repo() {
    for repo in $(cat dev/repos.list); do
        cd $repo
        $1
        cd ..
    done
}
