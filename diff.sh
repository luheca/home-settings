#!/usr/bin/env bash

if type python3 >/dev/null 2>&1; then
    python=python3
else
    python=python
fi

self_path=`${python} -c "import os; print(os.path.realpath(os.path.expanduser('$0')))"`
self_name=`basename $self_path`
self_dir="`/usr/bin/dirname $self_path`"

# Echo commands to diff files.
function echo_diff_files(){
    # Ignore hidden files, shell scripts, vim swap files, and OS-specific files.
    for f in `find $self_dir -path "$self_dir/.*" -prune -o -type f -a ! -name "*.sh" \
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
        echo "diff -C2 ~/$dot $src_dot;"
    done
}

echo "# To diff"
echo -e "$(echo_diff_files)"
