# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tesseract/tesseract-2.04-r1.ebuild,v 1.8 2012/06/04 11:40:10 jlec Exp $

EAPI="4"

inherit eutils autotools

DESCRIPTION="An OCR Engine that was developed at HP and now at Google"
HOMEPAGE="http://code.google.com/p/tesseract-ocr/"
SRC_URI="http://tesseract-ocr.googlecode.com/files/${P}.tar.gz
	http://tesseract-ocr.googlecode.com/files/${PN}-ocr-${PV}.eng.tar.gz
	http://tesseract-ocr.googlecode.com/files/eng.traineddata.gz
	linguas_ru? ( http://tesseract-ocr.googlecode.com/files/rus.traineddata.gz )"

RESTRICT="nomirror"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64  ~x86"
IUSE="examples linguas_ru"

DEPEND="media-libs/leptonica"
RDEPEND="${DEPEND}"

src_prepare() {
	# move language files to have them installed
	mv "${WORKDIR}"/tesseract-ocr/tessdata/* "${S}/tessdata/" || die "move language files failed"

	# remove obsolete makefile, install target only in uppercase Makefile
	eautoreconf
}

src_configure() {
	#./autogen.sh
	econf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	mv "${WORKDIR}"/*traineddata "${D}/usr/share/tessdata/" || die "move treined data files failed"

	dodoc AUTHORS ChangeLog NEWS README ReleaseNotes || die "dodoc failed"

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins eurotext.tif phototest.tif || die "doins failed"
	fi
}
