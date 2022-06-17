#!/usr/bin/env bash

self_path=`/bin/readlink -f "$0"` # The absolute path of this script
self_name=`basename $self_path`
self_dir="`/usr/bin/dirname $self_path`"

# Echo commands to diff files.
function echo_diff_files(){
    ## Ignore this repository's .hg, .hgignore, .git, .gitignore, or scripts
    for f in `find $self_dir -path "$self_dir/.*" -prune -o -type f -a ! -name "*.sh" -printf "%P\n"`
    do
        dot=".$f"
        echo "diff -C2 $self_dir/$f ~/$dot;"
    done
}

echo "# To diff"
echo -e "$(echo_diff_files)"
