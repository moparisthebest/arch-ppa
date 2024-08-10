pkgname=initramfs-pgp-encrypt
pkgdesc="initramfs hook that adds PGP smartcard and Dvorak support while keeping regular LUKS support"
pkgver=1.0
pkgrel=1
license=(AGPL-3.0)
arch=(any)
depends=(gnupg)
install=${pkgname}.install
source=(pgp-encrypt-hook
		pgp-encrypt-install)
sha256sums=('SKIP'
            'SKIP')

build() {
	return 0
}

package() {
	mkdir -p "${pkgdir}/usr/lib/initcpio/hooks"
	mkdir -p "${pkgdir}/usr/lib/initcpio/install"

	cp "${srcdir}/pgp-encrypt-hook" "${pkgdir}/usr/lib/initcpio/hooks/pgp-encrypt"
	cp "${srcdir}/pgp-encrypt-install" "${pkgdir}/usr/lib/initcpio/install/pgp-encrypt"
}
