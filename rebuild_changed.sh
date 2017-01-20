#!/bin/bash

script="./arch-ppa"

[ "$1" == '-d' ] && script="echo $script" && shift

$script rebuild aur $(comm -23 <(git status | grep -o 'src/[^/]*/PKGBUILD' | sed -e 's@^src/@@' -e 's@/PKGBUILD$@@' | sort | uniq) <(echo "$@" | tr ' ' '\n' | sort | uniq) | tr '\n' ' ')
