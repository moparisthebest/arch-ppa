#!/bin/bash
set -e
cd aur
cp -a /etc/pacman.conf /etc/pacman.d/mirrorlist ./

# sign everything
gpg -u 'ECB9B8CBAAC68C03!' -b pacman.conf
gpg -u 'ECB9B8CBAAC68C03!' -b mirrorlist

rsync -av --stats --progress --delete ./ root@mytorrentflux:/pacman/aur/
