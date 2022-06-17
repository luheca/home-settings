#!/usr/bin/env bash

if type python3 >/dev/null 2>&1; then
    python=python3
else
    python=python
fi

target_host=$1

#self_path=`/bin/readlink -f "$0"` # The absolute path of this script
self_path=`${python} -c "import os; print(os.path.realpath(os.path.expanduser('$0')))"`
self_name=`basename $self_path`
self_dir="`/usr/bin/dirname $self_path`"

# Temporary directory for storing home settings.
tmp_hs='~/tmp-hs'

# Echo commands to create the directory structure as needed.
function echo_create_dirs(){
    for f in `find $self_dir -mindepth 1 -path "$self_dir/.*" -prune -o -type d -print`
    do
        dot=".${f#${self_dir}/}"
        echo "test -e ~/$dot || mkdir -v -p ~/$dot;"
    done
}

# Echo commands to update files.
# If $1 is provided (a non-zero length string), will assume source was copied into $tmp_hs
function echo_update_files(){
    ## Ignore this repository's .hg, .hgignore, .git, .gitignore, install and diff scripts, and *.swp
    for f in `find $self_dir -path "$self_dir/.*" -prune -o -path "$self_dir/install.sh" -prune -o -path "$self_dir/diff.sh" -prune -o -type f \
      -a ! -name "*.swp" -a ! -name "*.Darwin" -a ! -name "*.Linux" -print`
    do
        # Prefer OS-specific files if found
        if [ -f "${f}.$(uname -s)" ]
        then
          src_dot="${f}.$(uname -s)"
        else
          src_dot=$f
        fi
        dot=".${f#${self_dir}/}"

        if [ -n "$1" ]
        then
            echo "cp -v -b $tmp_hs/$f ~/$dot;"
        else
            echo "cp -v -b $src_dot ~/$dot;"
        fi
    done
}

rsync_opts="-avz"

if [ -n "$target_host" ]
then
    echo "# To install on a remote server"
    echo "rsync $rsync_opts -e ssh" ${self_dir}/ ${target_host}:$tmp_hs
    echo "ssh -n $USER@${target_host} '$(echo_create_dirs) $(echo_update_files 1) sed -i -e \"/# For non-Windows/{n;s/^#//;s#@HOME@#"'$HOME'"#g;}\" ~/.subversion/servers; rm -vrf $tmp_hs'"
else
    echo "# To install locally"
    echo -e "$(echo_create_dirs)\n$(echo_update_files)"
fi
