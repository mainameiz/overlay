# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="O.C.R easy (and free/libre)"
HOMEPAGE="http://lem.eui.upm.es/ocre.html"
SRC_URI="ftp://lem.eui.upm.es/pub/ocre/ocre_v0_042.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="nomirror"

DEPEND=">=sys-libs/glibc-2.7
	>=app-text/aspell-0.60
	>=dev-libs/atk-1.29.3
	>=dev-libs/glib-2.16.0:2
	>=media-libs/fontconfig-2.8.0
	>=media-libs/freetype-2.2.1:2
	>=x11-libs/gtk+-2.8.0:2
	>=x11-libs/pango-1.14.0
	>=x11-libs/cairo-1.2.4"

RDEPEND="${DEPEND}"

src_install() {
	DD="${D}/usr"
	cd ocre
	tar xzvf ocre-decsWood*.tgz
	emake DESTDIR="${DD}" depend
	emake DESTDIR="${DD}" ocre
	emake DESTDIR="${DD}" install installman
}
