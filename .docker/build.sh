#!/bin/bash

src_dir="$1"

#[ "$PKGS_TO_BUILD_IN_ORDER" == "" ] && PKGS_TO_BUILD_IN_ORDER='zpaq'

# refresh with: aurqueue * | tr '\n' ' '
# removed 'linux-aufs-lts'
[ "$PKGS_TO_BUILD_IN_ORDER" == "" ] && PKGS_TO_BUILD_IN_ORDER='mingw-w64-headers mingw-w64-binutils mingw-w64-headers-bootstrap mingw-w64-gcc-base python-pydns mingw-w64-crt python-rtslib-fb python-configshell-fb srb2kart-data srb2-data python-sleekxmpp python2-axolotl-curve25519-git python-pyspf python-pycares pi-hole-ftl libgcj17-bin trousers stoken libpcl freeradius-client ucspi-tcp mingw-w64-winpthreads perl-sys-virt hivex htmlcxx python2-dulwich evdi ncurses5-compat-libs zpaq zelda-roth xboxdrv wide-dhcpv6 webhook wallabag visual-studio-code-bin ttf-oxygen ttf-ms-fonts ts-spooler ternimal-git targetcli-fb srb2kart srb2 sonarr sendxmpp-rs-git sendxmpp-rs sendxmpp-py searx-py3 searx scallion rusty-keys-git rusty-keys runescape-launcher rootmp-hook redis-desktop-manager react-native-cli qt5-webengine-widevine qemu-user-static python2-axolotl-git python-postfix-policyd-spf python-aiodns prosody-mod-s2s-auth-dane prosody-hg-stable popstation_md popstation pkgsync pi-hole-standalone pi-hole-server php-imagick pdftk-bin pcem panda3d openhardwaremonitor openconnect-git odamex ocserv nginx-mainline-rtmp nextcloud-app-user-sql nextcloud-app-user-external nextcloud-app-passman mprime mkinitcpio-utils mkinitcpio-tinyssh mkinitcpio-netconf mkinitcpio-dropbear mingw-w64-gcc minecraft memtest86-efi makemkv luaunbound lua51-event lua-zlib libresonic libplatform-legacy libguestfs lgogdownloader kodi-standalone-socket-activation kodi-standalone-service kiwiirc jdk6 intellij-idea-ultimate-edition inspircd hg-git-hg gajim-plugin-omemo fuse-zip filebot ffmpeg-omx evdi-git emulationstation-themes emulationstation-git emulationstation-autoscraper doom-wads displaylink dino-git dex2jar cryptsetup-multidisk-ssh cryptsetup-multidisk crispy-doom coturn comskip chocolate-doom-git chocolate-doom ccextractor brother-hl2170w broadcom-bt-firmware-git bluez-utils-compat binfmt-support binfmt-qemu-static biboumi-git biboumi barrier aurutils archivemount android-emulator alt-version-switcher'

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
