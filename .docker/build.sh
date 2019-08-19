#!/bin/bash

src_dir="$1"

#[ "$PKGS_TO_BUILD_IN_ORDER" == "" ] && PKGS_TO_BUILD_IN_ORDER='zpaq'

# had to remove 'webkitgtk webkitgtk2 truecraft-git' from here because webkitgtk took too many hours to build...
# removed 'linux-pf-lts linux-aufs-lts'
# removed 'mingw-w64-headers mingw-w64-binutils mingw-w64-headers-bootstrap mingw-w64-gcc-base mingw-w64-crt mingw-w64-winpthreads cloog mingw-w64-gcc'
[ "$PKGS_TO_BUILD_IN_ORDER" == "" ] && PKGS_TO_BUILD_IN_ORDER='python-pycares python-pydns python-rtslib-fb python-configshell-fb srb2kart-data srb2-data python2-schedule python2-spotipy python-sleekxmpp glib2-static pcre-static python2-axolotl-curve25519-git python-aiodns python-pyspf pi-hole-ftl libgcj17-bin auracle-git trousers stoken libpcl freeradius-client php-imagick ucspi-tcp perl-sys-virt hivex htmlcxx python2-dulwich evdi osl isl ncurses5-compat-libs zpaq zelda-roth xboxdrv wireguard-module-arch wide-dhcpv6 webhook wallabag visual-studio-code-bin vdfuse ttf-oxygen ttf-ms-fonts ts-spooler ternimal-git targetcli-fb systemd-cron-next srb2kart srb2 spotify-ripper spotify sonarr sendxmpp-rs-git sendxmpp-rs sendxmpp-py searx-py3 searx scallion rusty-keys-git rusty-keys runescape-launcher rootmp-hook reprepro redis-desktop-manager react-native-cli qt5-webengine-widevine qemu-user-static python2-pyliblzma python2-axolotl-git python-spotify python-slixmpp python-postfix-policyd-spf python-authres prosody-mod-s2s-auth-dane prosody-hg-stable popstation_md popstation pkgsync pi-hole-standalone pi-hole-server php-zmq perl-file-libmagic pdftk-bin pcem panda3d pacaur openhardwaremonitor openconnect-git odamex ocserv nginx-mainline-rtmp nextcloud-app-user-sql nextcloud-app-user-external nextcloud-app-passman nextcloud-app-keeweb mprime movim-git mkinitcpio-utils mkinitcpio-tinyssh mkinitcpio-netconf mkinitcpio-dropbear minecraft memtest86-efi mellowplayer makemkv luaunbound lua51-event lua-zlib libresonic libplatform-legacy libguestfs lib32-libgme lgogdownloader kodi-standalone-socket-activation kodi-standalone-service kiwiirc jitsi jdk6 intellij-idea-ultimate-edition inspircd hg-git-hg gajim-plugin-omemo fuse-zip filebot ffmpeg-omx factorio-demo evdi-git emulationstation-themes emulationstation-git emulationstation-autoscraper doom-wads displaylink dino-git dex2jar cryptsetup-multidisk-ssh cryptsetup-multidisk crispy-doom coturn comskip chocolate-doom-git chocolate-doom ccextractor brother-hl2170w broadcom-bt-firmware-git bluez-utils-compat bitpim-release binfmt-support binfmt-qemu-static biboumi-git biboumi barrier aurutils atheme archivemount android-emulator alt-version-switcher mingw-w64-headers mingw-w64-binutils mingw-w64-headers-bootstrap mingw-w64-gcc-base mingw-w64-crt mingw-w64-winpthreads cloog mingw-w64-gcc'

export PKGDEST="$2"

failed=''

for dir in $PKGS_TO_BUILD_IN_ORDER
do
    cd $dir
    # todo: build some source packages too or?
    SECONDS=0
    sudo -u nobody PKGDEST=$PKGDEST makepkg --syncdeps --rmdeps --skippgpcheck --noconfirm
    success=$?
    echo "$SECONDS $dir ---seconds_to_build---"
    if [ $success -ne 0 ]; then
        # failed, append to failed string
        failed="$failed $dir"
        # this is for making logs easy to grep for failure reasons
        echo "---failed--- $dir ---failed---"
    else
        sudo -u nobody PKGDEST=$PKGDEST makepkg --packagelist | xargs repo-add "$PKGDEST/aur.db.tar.gz"
        pacman -Sy
    fi
    cd "$src_dir"
done 2>&1 | tee "$PKGDEST/build.log"

gzip "$PKGDEST/build.log"
rm -f "$PKGDEST/"*.tar.gz.old

[ "$failed" != '' ] && echo "failed packages: $failed"

echo -n "$failed" > "$PKGDEST/failed.txt"
