# Maintainer:  Vitalii Kuzhdin <vitaliikuzhdin@gmail.com>
# Maintainer:  artist for XLibre

_basename="xf86-input-libinput"
pkgname="${_basename//xf86/xlibre}"
pkgver=1.5.1.0
pkgrel=1
pkgdesc="Generic input driver for the XLibre server based on libinput"
arch=('aarch64' 'x86_64')
url="https://github.com/X11Libre/${_basename}/"
license=('MIT')
depends=('glibc' 'libinput>=1.11')
makedepends=('libx11' 'libxi' 'meson>=0.50' 'xlibre-xserver-devel' 'xorgproto' 'X-ABI-XINPUT_VERSION=26.0')
provides=('xf86-input-libinput-xlibre' "${_basename}")
conflicts=("${_basename}" 'xf86-input-libinput-xlibre' 'xorg-server<1.19.0' 'X-ABI-XINPUT_VERSION<26' 'X-ABI-XINPUT_VERSION>=27')
replaces=('xf86-input-libinput-xlibre')
groups=('xlibre-drivers')
_pkgsrc="${_basename}-xlibre-${_basename}-${pkgver}"
source=("${_pkgsrc}.tar.gz::${url}/archive/refs/tags/xlibre-${_basename}-${pkgver}.tar.gz")
b2sums=('b4a6061dd310c3e900606a128dc28c83b6e0dce6e6aa92e30c1d5788c5f0b6683b41e0e3e24ae8f4cf5014ba217a720240427c9f835038fe1b2794b58a330059')

build() {
  local meson_options=(
    "${_pkgsrc}"
    "${_pkgsrc}/build"
  )
  cd "${srcdir}"
  arch-meson "${meson_options[@]}"
  meson compile -C "${_pkgsrc}/build"
}

package() {
  cd "${srcdir}"
  meson install -C "${_pkgsrc}/build" --destdir "${pkgdir}"

  cd "${_pkgsrc}"
  install -vDm644 "README.md" "${pkgdir}/usr/share/doc/${pkgname}/README.md"
  install -vDm644 "COPYING"   "${pkgdir}/usr/share/licenses/${pkgname}/COPYING"
}
