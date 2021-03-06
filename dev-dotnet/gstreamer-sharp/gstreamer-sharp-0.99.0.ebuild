# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools base

SLOT="3"
DESCRIPTION="gtk bindings for mono"
LICENSE="GPL-2"
HOMEPAGE="http://www.mono-project.com/GtkSharp"
KEYWORDS="~amd64 ~x86 ~ppc"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar"
IUSE="debug"

GTK_SHARP_COMPONENT_SLOT="3"
RESTRICT="test"

RDEPEND="
	>=dev-lang/mono-3.0
	>=dev-dotnet/glib-sharp-2.99.2:3
	>=dev-libs/glib-2.18.1:2
	>=sys-devel/autoconf-2.6.1
	=sys-devel/automake-1.11*
	>=media-libs/gst-plugins-base-1.0.5-r1:1.0
	media-libs/gst-plugins-good:1.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/automake:1.11"

src_unpack() {
	mkdir "${S}" || die "Create dir failed"
	cd "${S}" || die "cd failed"
	unpack ${PF}.tar || die unpack failed
}

src_prepare() {
	base_src_prepare
	eautoreconf
	libtoolize
}

