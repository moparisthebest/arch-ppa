#!/bin/bash
set -e
cd aur
cp -a /etc/pacman.conf /etc/pacman.d/mirrorlist ./

# sign everything
gpg -v pacman.conf.sig 2>/dev/null || (rm -f pacman.conf.sig; gpg -u 'ECB9B8CBAAC68C03!' -b pacman.conf)
gpg -v mirrorlist.sig 2>/dev/null || (rm -f mirrorlist.sig; gpg -u 'ECB9B8CBAAC68C03!' -b mirrorlist)

rsync -av --stats --progress --delete ./ root@mytorrentflux:/pacman/aur/
