# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gkeyfile-sharp/gkeyfile-sharp-0.1.ebuild,v 1.4 2012/05/04 03:56:58 jdhore Exp $

EAPI=2
inherit autotools mono

DESCRIPTION="C# binding for gkeyfile"
HOMEPAGE="http://launchpad.net/gkeyfile-sharp http://github.com/mono/gkeyfile-sharp"
SRC_URI="http://github.com/mono/${PN}/tarball/GKEYFILE_SHARP_0_1 -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-dotnet/glib-sharp-2.12.9:2
	>=dev-dotnet/gtk-sharp-gapi-1.9:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS
}