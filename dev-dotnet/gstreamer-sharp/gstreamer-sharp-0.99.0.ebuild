# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit dotnet autotools base

SLOT="3"
DESCRIPTION="gtk bindings for mono"
LICENSE="GPL-2"
HOMEPAGE="http://www.mono-project.com/GtkSharp"
KEYWORDS="~amd64 ~x86 ~ppc"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${PN}-${PV}.tar.gz -> ${PN}-${PV}.tar"
IUSE="debug"

GTK_SHARP_COMPONENT_SLOT="2"
RESTRICT="test"

#	cli-common-dev (>= 0.5.7),
#	libglib3.0-cil-dev (>= 2.99),
#	libglib2.0-dev (>= 2.18.1),

RDEPEND="
	>=dev-lang/mono-3.0
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

#src_configure() {
#	econf	--disable-static \
#		--disable-dependency-tracking \
#		--disable-maintainer-mode \
#		$(use_enable debug)
#	eautoreconf
#}

src_compile() {
	emake
}
#
src_install() {
	default
	dotnet_multilib_comply
#	sed -i "s/\\r//g" "${D}"/usr/bin/* || die "sed failed"
}

