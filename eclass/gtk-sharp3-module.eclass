# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gtk-sharp3-module.eclass,v 1.37 2014/01/19 21:13:08 moult Exp $

# @ECLASS: gtk-sharp3-module.eclass
# @MAINTAINER:
# dotnet@gentoo.org
# @BLURB: Manages the modules of the gtk-, gnome-, and gnome-desktop-sharp tarballs
# @DESCRIPTION:
# This eclass provides phase functions and helper functions for the modules
# of the gtk-sharp, gnome-sharp and gnome-desktop-sharp tarballs.
# PLEASE TAKE NOTE: ONLY FOR EAPI-3 EBUILDS

WANT_AUTOMAKE=none
WANT_AUTOCONF=none

inherit eutils mono multilib libtool autotools base versionator

case ${EAPI:-0} in
	2) die "Unsupported EAPI" ;;
	3|4|5) ;;
	*) die "Unknown EAPI." ;;
esac

# @ECLASS-VARIABLE: GTK_SHARP_MODULE
# @DESCRIPTION:
# The name of the Gtk# module.
# Default value: ${PN/-sharp/}
GTK_SHARP_MODULE=${GTK_SHARP_MODULE:=${PN/-sharp/}}

# @ECLASS-VARIABLE: GTK_SHARP_MODULE_DIR
# @DESCRIPTION:
# The subdirectory of S in which GTK_SHARP_MODULE is installed.
# Default value: ${PN/-sharp/}
GTK_SHARP_MODULE_DIR=${GTK_SHARP_MODULE_DIR:=${PN/-sharp/}}

# @ECLASS-VARIABLE: GTK_SHARP_REQUIRED_VERSION
# @DESCRIPTION:
# The version of the gtk-sharp tarball this package requires.
# Optional.
GTK_SHARP_REQUIRED_VERSION="${GTK_SHARP_REQUIRED_VERSION}"

# @ECLASS-VARIABLE: gapi_users_list
# @DESCRIPTION:
# List of modules that use one of gapi2-codegen, gapi2-fixup or gapi2-parser
# No ebuild-serviceable parts inside.
gapi_users_list="art gnome gnomevfs ${gnome_desktop_sharp_module_list} atk gtk gdk glade pango"

# @ECLASS-VARIABLE: PV_MAJOR
# @DESCRIPTION:
# The first two components of the PV variable.
PV_MAJOR=$(get_version_component_range 1-2)

# @FUNCTION: add_bdepend
# @USAGE: <package atom>
# @DESCRIPTION:
# Adds to the DEPEND variable
add_bdepend() {
	[[ ${#@} -eq 1 ]] || die "${FUNCNAME} needs ONE (1) argument"
	DEPEND="${DEPEND} $@"
}

# @FUNCTION: add_rdepend
# @USAGE: <package atom>
# @DESCRIPTION:
# Adds to the RDEPEND variable
add_rdepend() {
	[[ ${#@} -eq 1 ]] || die "${FUNCNAME} needs ONE (1) argument"
	RDEPEND="${RDEPEND} $@"
}

# @FUNCTION: add_depend
# @USAGE: <package atom>
# @DESCRIPTION:
# Adds to the DEPEND and RDEPEND variables
add_depend() {
	[[ ${#@} -eq 1 ]] || die "${FUNCNAME} needs ONE (1) argument"
	DEPEND="${DEPEND} $@"
	RDEPEND="${RDEPEND} $@"
}

# @ECLASS-VARIABLE: TARBALL
# @DESCRIPTION:
# The GtkSharp modules are currently divided into three seperate tarball
# distributions. The TARBALL variable holds the name of the tarball
# to which GTK_SHARP_MODULE belongs.
case ${GTK_SHARP_MODULE} in
	glib|glade|gtk|gdk|atk|pango|gio|cairo|gtk-dotnet|gtk-gapi|gtk-docs)
		TARBALL="gtk-sharp3"
		TARBALL_SRC="gtk-sharp"
		case ${PVR} in
			2.99.2)
				SRC_URI="http://andhor.com.ua/${TARBALL_SRC}-2.99.2.patch.bz2"
				PATCHES=(
					"${WORKDIR}/${TARBALL_SRC}-2.99.2.patch"
				)
				EAUTORECONF="YES"
				add_bdepend "=sys-devel/automake-1.13.3*"
				add_bdepend ">=sys-devel/autoconf-2.61"
			;;
			2.99.3)
				SRC_URI="http://andhor.com.ua/${TARBALL_SRC}-2.99.3.patch.bz2"
				PATCHES=(
					"${WORKDIR}/${TARBALL_SRC}-2.99.3.patch"
				)
				EAUTORECONF="YES"
				add_bdepend "=sys-devel/automake-1.13.3*"
				add_bdepend ">=sys-devel/autoconf-2.61"
			;;
		esac
		;;
	*)
		eerror "Huh? Sonny boy, looks like your GTK_SHARP_MODULE is not on the approved list. BAILING!"
		die "How did we get here!!?"
		;;
esac

case ${PF} in
	#gtk-sharp tarball
	gtk-sharp-docs*)
		add_depend ">=dev-lang/mono-2.0"
		;;
	gtk-sharp-gapi*)
		add_rdepend "!<=dev-dotnet/gtk-sharp-2.99.1:3"
		add_depend "dev-perl/XML-LibXML"
		;;
	gtk-sharp-*)
		add_bdepend "~dev-dotnet/gtk-sharp-gapi-${PV}"
		add_depend "~dev-dotnet/glib-sharp-${PV}"
		add_depend "~dev-dotnet/atk-sharp-${PV}"
		add_depend "~dev-dotnet/gdk-sharp-${PV}"
		add_depend "~dev-dotnet/gio-sharp-${PV}"
		add_depend "~dev-dotnet/cairo-sharp-${PV}"
		add_depend "~dev-dotnet/pango-sharp-${PV}"
		;;
	gdk-sharp-*)
		add_bdepend "~dev-dotnet/gtk-sharp-gapi-${PV}"
		add_depend "~dev-dotnet/glib-sharp-${PV}"
		add_depend "~dev-dotnet/cairo-sharp-${PV}"
		add_depend "~dev-dotnet/pango-sharp-${PV}"
		add_depend "x11-libs/gtk+:3"
		add_rdepend "!<=dev-dotnet/gtk-sharp-2.99.1:3"
		;;
	atk-sharp-*)
		add_bdepend "~dev-dotnet/gtk-sharp-gapi-${PV}"
		add_depend "~dev-dotnet/glib-sharp-${PV}"
		add_depend "dev-libs/atk"
		add_rdepend "!<=dev-dotnet/gtk-sharp-2.99.1:3"
		;;
	glib-sharp-*)
		add_rdepend "!<=dev-dotnet/gtk-sharp-2.99.1:3"
		add_depend "dev-libs/glib:2"
		;;
	pango-sharp-*)
		add_bdepend "~dev-dotnet/gtk-sharp-gapi-${PV}"
		add_depend "~dev-dotnet/glib-sharp-${PV}"
		add_depend "~dev-dotnet/cairo-sharp-${PV}"
		add_depend "x11-libs/pango"
		add_rdepend "!<=dev-dotnet/gtk-sharp-2.99.1:3"
		;;
	gio-sharp-*)
		add_bdepend "~dev-dotnet/gtk-sharp-gapi-${PV}"
		add_depend "~dev-dotnet/glib-sharp-${PV}"
		add_depend ">=dev-libs/glib-2.22:2"
		add_rdepend "!<=dev-dotnet/gtk-sharp-2.99.1:3"
		;;
	cairo-sharp-*)
		add_bdepend "~dev-dotnet/gtk-sharp-gapi-${PV}"
		add_depend "~dev-dotnet/glib-sharp-${PV}"
		add_depend ">=x11-libs/cairo-1.12.0"
		add_rdepend "!<=dev-dotnet/gtk-sharp-2.99.1:3"
		;;
	gtk-dotnet-*)
		add_depend "~dev-dotnet/glib-sharp-${PV}"
		add_depend "~dev-dotnet/gdk-sharp-${PV}"
		add_depend "~dev-dotnet/pango-sharp-${PV}"
		add_depend "~dev-dotnet/gtk-sharp-${PV}"
		add_depend "dev-lang/mono[-minimal]"
		add_rdepend "!<=dev-dotnet/gtk-sharp-2.99.1:3"
		;;
	glade-sharp-*)
		add_bdepend "~dev-dotnet/gtk-sharp-gapi-${PV}"
		add_depend "~dev-dotnet/glib-sharp-${PV}"
		add_depend "~dev-dotnet/atk-sharp-${PV}"
		add_depend "~dev-dotnet/gdk-sharp-${PV}"
		add_depend "~dev-dotnet/gtk-sharp-${PV}"
		add_depend "~dev-dotnet/pango-sharp-${PV}"
		add_depend ">=gnome-base/libglade-2.3.6:2.0"
		;;
esac

# @ECLASS-VARIABLE: DESCRIPTION
# @DESCRIPTION:
# Default value: GtkSharp's ${GTK_SHARP_MODULE} module of the ${TARBALL} tarball
DESCRIPTION="GtkSharp's ${GTK_SHARP_MODULE} module of the ${TARBALL} tarball"
# @ECLASS-VARIABLE: HOMEPAGE
# @DESCRIPTION:
# Default value: http://www.mono-project.com/GtkSharp
HOMEPAGE="http://www.mono-project.com/GtkSharp"
# @ECLASS-VARIABLE: LICENSE
# @DESCRIPTION:
# Default value: LGPL-2.1
LICENSE="LGPL-2.1"

add_depend	">=dev-lang/mono-2.0.1"
add_bdepend	">=sys-apps/sed-4"
add_bdepend	"virtual/pkgconfig"
add_bdepend	">=app-shells/bash-3.1"

IUSE="debug"
# @ECLASS-VARIABLE: S
# @DESCRIPTION:
# Default value: ${WORKDIR}/${TARBALL}-${PV}
S="${WORKDIR}/${TARBALL_SRC}-${PV}"
# @ECLASS-VARIABLE: SRC_URI
# @DESCRIPTION:
# Default value: mirror://gnome/sources/${TARBALL}/${PV_MAJOR}/${TARBALL}-${PV}.tar.bz2
SRC_URI="${SRC_URI}
	mirror://gnome/sources/${TARBALL_SRC}/${PV_MAJOR}/${TARBALL_SRC}-${PV}.tar.xz"

# @FUNCTION: get_sharp_apis
# @USAGE: <type> <pkgconfig-package>
# @RETURN: .NET API files
# @DESCRIPTION:
# Given a valid pkg-config package, will return a list of API xml files.
# <type> can be either --prefixed or --bare. If prefixed, each API file
# will be prefixed with -I:
get_sharp_apis() {
	[[ ${#@} -eq 2 ]] || die "${FUNCNAME} needs two arguments"
	get_sharp_assemblies "$@"
}

# @FUNCTION: get_sharp_assemblies
# @USAGE: <type> <pkgconfig-package>
# @RETURN: .NET .dll assemblies
# @DESCRIPTION:
# Given a valid pkg-config package, will return a list of .dll assemblies.
# <type> can be either --prefixed or --bare. If prefixed, each .dll file
# will be prefixed with -r:
get_sharp_assemblies() {
	[[ ${#@} -eq 2 ]] || die "${FUNCNAME} needs two arguments"
	local string config=libs prefix="-r:"
	local -a rvalue
	[[ "${FUNCNAME[1]}" = "get_sharp_apis" ]] && config=cflags && prefix="-I:"
	for string in $(pkg-config --${config} ${2} 2> /dev/null)
	do
		rvalue+=( ${string#-?:} )
	done

	case $1 in
		--bare)
			:
			;;
		--prefixed)
			for (( i=0 ; i< ${#rvalue[@]} ; i++ ))
			do
				rvalue[$i]=${prefix}${rvalue[$i]}
			done
			;;
		*)
			die "${FUNCNAME}: Unknown parameter"
			;;
	esac
	echo "${rvalue[@]}"
}

# @FUNCTION: phase_hook
# @USAGE: <prefix>
# @DESCRIPTION:
# Looks for functions named <prefix>_caller_suffix and executes them.
# _caller_suffix is the calling function with the prefix
# gtk-sharp3-module removed.
phase_hook() {
	[[ ${#@} -eq 1 ]] || die "${FUNCNAME} needs one argument"
	if [[ "$(type -t ${1}${FUNCNAME[1]#gtk-sharp3-module})" = "function" ]]
	then
		ebegin "Phase-hook: Running ${1}${FUNCNAME[1]#gtk-sharp3-module}"
		${1}${FUNCNAME[1]#gtk-sharp3-module}
		eend 0
	fi
}

# @FUNCTION: ac_path_prog_override
# @USAGE: <PROG> [path]
# @DESCRIPTION:
# Override AC_PATH_PROG() autoconf macros. Path will be set to " " if
# not specified.
ac_path_prog_override() {
	if [[ ${#@} -lt 1 || ${#@} -gt 2 ]]
	then
		eerror "${FUNCNAME[0]} requires at least one parameter and takes at most two:"
		eerror "AC_PATH_PROG(PARAM1, param2)"
		die "${FUNCNAME[0]} requires at least one parameter and takes at most two:"
	fi
	export  ac_cv_path_${1}="${2:- }"
}


# @FUNCTION: pkg_check_modules_override
# @USAGE: <GROUP> [package1] [package2]
# @DESCRIPTION:
# Will export the appropriate variables to override PKG_CHECK_MODULES autoconf
# macros, with the string " " by default. If packages are specified, they will
# be looked up with pkg-config and the appropriate LIBS and CFLAGS substituted.
# LIBS and CFLAGS can also be specified per-package with the following syntax:
# @CODE
# 	package=LIBS%CFLAGS
# @CODE
# = and % have no effect unless both are specified.
# Here is an example:
# @CODE
# 	pkg_check_modules_override GASH "gtk+-2.0=-jule%" gobject-2.0
# @CODE
# The above example will do:
# export GASH_CFLAGS+=" -jule"
# export GASH_LIBS+=" "
# export GASH_CFLAGS+=" $(pkg-config --cflags gobject-2.0)"
# export GASH_LIBS+=" $(pkg-config --libs gobject-2.0)"
#
# NOTE: If a package is not found, the string " " will be inserted in place of
# <GROUP>_CFLAGS  and <GROUP>_LIBS
pkg_check_modules_override() {
	local package
	local group="${1}"
	local packages="${*:2}"
	export ${group}_CFLAGS=" "
	export ${group}_LIBS=" "

	if [[ ${#@} -lt 1 ]]
	then
		eerror "${FUNCNAME[0]} requires at least one parameter: GROUP"
		eerror "PKG_CHECK_MODULES(GROUP, package1 package2 etc)"
		die "${FUNCNAME[0]} requires at least one parameter: GROUP"
	fi

	for package in $packages
	do
		if [[ ${package/=} != ${package} && ${package/\%} != ${package} ]]
		then
			package_cflag_libs=${package##*=}
			export ${group}_CFLAGS+=" ${package_cflag_libs%%\%*}"
			export ${group}_LIBS+=" ${package_cflag_libs##*\%}"
		else
			if pkg-config --exists $package
			then
				export ${group}_CFLAGS+=" $(pkg-config --cflags $package)"
				export ${group}_LIBS+=" $(pkg-config --libs $package)"
			else
			export ${group}_CFLAGS+=" "
			export ${group}_LIBS+=" "
			fi
		fi
	done
}

# @FUNCTION: gtk-sharp3-tarball-post_src_prepare
# @DESCRIPTION:
# Runs a M-m-m-monster sed on GTK_SHARP_MODULE_DIR to convert references to
# local assemblies to the installed ones. Is only called by src_prepare when
# $GTK_SHARP_MODULE is a member of $gtk_sharp_module_list.



gtk-sharp3-tarball-post_src_prepare() {
	ExPREFIX=${EPREFIX}
	has "${EAPI:-0}" 3 && ! use prefix && ExPREFIX=
	cd "${S}/${GTK_SHARP_MODULE_DIR}"
	sed -i \
		-e "s; \$(top_srcdir)/glib/glib-api.xml; $(get_sharp_apis --bare glib-sharp-3.0);"			\
		-e "s; \$(top_srcdir)/atk/atk-api.xml; $(get_sharp_apis --bare atk-sharp-3.0);"				\
		-e "s; \$(top_srcdir)/gdk/gdk-api.xml; $(get_sharp_apis --bare gdk-sharp-3.0);"				\
		-e "s; \$(top_srcdir)/gtk/gtk-api.xml; $(get_sharp_apis --bare gtk-sharp-3.0);"				\
		-e "s; \$(top_srcdir)/gio/gio-api.xml; $(get_sharp_apis --bare gio-sharp-3.0);"				\
		-e "s; \$(top_srcdir)/pango/pango-api.xml; $(get_sharp_apis --bare pango-sharp-3.0);"			\
		-e "s; \$(top_srcdir)/cairo/cairo-api.xml; $(get_sharp_apis --bare cairo-sharp-3.0);"			\
		-e "s; \$(top_builddir)/atk/atk-api.xml; $(get_sharp_apis --bare atk-sharp-3.0);"			\
		-e "s; \$(top_builddir)/gio/gio-api.xml; $(get_sharp_apis --bare gio-sharp-3.0);"			\
		-e "s; \$(top_builddir)/gdk/gdk-api.xml; $(get_sharp_apis --bare gdk-sharp-3.0);"			\
		-e "s; \$(top_builddir)/pango/pango-api.xml; $(get_sharp_apis --bare pango-sharp-3.0);"			\
		-e "s; \$(top_builddir)/glib/glib-sharp.dll; $(get_sharp_assemblies --bare glib-sharp-3.0);g"		\
		-e "s; \$(top_builddir)/atk/atk-sharp.dll; $(get_sharp_assemblies --bare atk-sharp-3.0);g"		\
		-e "s; \$(top_builddir)/gdk/gdk-sharp.dll; $(get_sharp_assemblies --bare gdk-sharp-3.0);g"		\
		-e "s; \$(top_builddir)/gtk/gtk-sharp.dll; $(get_sharp_assemblies --bare gtk-sharp-3.0);g"		\
		-e "s; \$(top_builddir)/gio/gio-sharp.dll; $(get_sharp_assemblies --bare gio-sharp-3.0);g"		\
		-e "s; \$(top_builddir)/pango/pango-sharp.dll; $(get_sharp_assemblies --bare pango-sharp-3.0);g"	\
		-e "s; \$(top_builddir)/cairo/cairo-sharp.dll; $(get_sharp_assemblies --bare cairo-sharp-3.0);g"	\
		-e "s; \.\./glib/glib-sharp.dll; $(get_sharp_assemblies --bare glib-sharp-3.0);g"			\
		-e "s; \.\./atk/atk-sharp.dll; $(get_sharp_assemblies --bare atk-sharp-3.0);g"				\
		-e "s; \.\./gdk/gdk-sharp.dll; $(get_sharp_assemblies --bare gdk-sharp-3.0);g"				\
		-e "s; \.\./gtk/gtk-sharp.dll; $(get_sharp_assemblies --bare gtk-sharp-3.0);g"				\
		-e "s; \.\./gio/gio-sharp.dll; $(get_sharp_assemblies --bare gio-sharp-3.0);g"				\
		-e "s; \.\./pango/pango-sharp.dll; $(get_sharp_assemblies --bare pango-sharp-3.0);g"			\
		-e "s; \.\./cairo/cairo-sharp.dll; $(get_sharp_assemblies --bare cairo-sharp-3.0);g"			\
		-e "s;\$(RUNTIME) \$(top_builddir)/parser/gapi-fixup.exe;${ExPREFIX}/usr/bin/gapi3-fixup;"		\
		-e "s;\$(RUNTIME) \$(top_builddir)/generator/gapi-fixup.exe;${ExPREFIX}/usr/bin/gapi3-fixup;"		\
		-e "s;\$(RUNTIME) \$(top_builddir)/generator/gapi_codegen.exe;${ExPREFIX}/usr/bin/gapi3-codegen;"	\
		-e "s;\$(SYMBOLS) \$(top_builddir)/parser/gapi-fixup.exe;\$(SYMBOLS);"					\
		-e "s;\$(SYMBOLS) \$(top_builddir)/generator/gapi-fixup.exe;\$(SYMBOLS);"				\
		-e "s;\$(INCLUDE_API) \$(top_builddir)/generator/gapi_codegen.exe;\$(INCLUDE_API);"			\
		$(find . -name Makefile.in) || die "failed to fix ${TARBALL}-tarball makefiles"
}

# @FUNCTION: gtk-sharp3-module_src_prepare
# @DESCRIPTION:
# Runs autopatch from base.eclass, eautoreconf if EAUTORECONF is set to any
# value.
# Contains a phase_hook, runs very last.
# phase_hook prefix trigger: ${TARBALL}-tarball-post
# Is exported.
gtk-sharp3-module_src_prepare() {
	base_src_prepare
# @ECLASS-VARIABLE: EAUTORECONF
# @DESCRIPTION:
# If set, EAUTORECONF will be run during src_prepare.
	[[ ${EAUTORECONF} ]] && eautoreconf
	phase_hook ${TARBALL}-tarball-post
	elibtoolize
}

# @FUNCTION: gtk-sharp3-tarball_src_configure
# @DESCRIPTION:
# Sets some environment variables that will allow us to make the dependencies
# for each ebuild be only its own dependencies, without patching configure.
# Is only called by gtk-sharp-module_src_configure when $GTK_SHARP_MODULE
# is a member of $gtk_sharp_module_list.
gtk-sharp3-tarball_src_configure() {
	pkg_check_modules_override GLIB gobject-2.0
	pkg_check_modules_override GIO gio-2.0
	pkg_check_modules_override PANGO pango
	pkg_check_modules_override ATK atk
	pkg_check_modules_override GTK gtk+-3.0
	pkg_check_modules_override GLADE libglade-2.0
	pkg_check_modules_override CAIRO cairo
}

# @FUNCTION: gtk-sharp3-module_src_configure
# @USAGE: [econf-arguments]
# @DESCRIPTION:
# Calls econf with some default values.
# Contains a phase_hook, run before econf.
# phase_hook prefix trigger: ${TARBALL}-tarball
# Is exported.

gtk-sharp3-module_src_configure() {
	phase_hook ${TARBALL}-tarball
	econf	--disable-static \
		--disable-dependency-tracking \
		--disable-maintainer-mode \
		$(use debug &&echo "--enable-debug" ) \
		${@} || die "econf failed"
}

# @FUNCTION: gtk-sharp3-module_src_compile
# @DESCRIPTION:
# Calls emake in the subdir of the module.
# Sets CSC=/usr/bin/gmcs. Deletes top_srcdir Makefiles to prevent recursing in
# case we missed some dll references.
# Is exported.
gtk-sharp3-module_src_compile() {
	rm -f "{S}"/Makefile &> /dev/null
	cd "${S}/${GTK_SHARP_MODULE_DIR}"
	emake CSC=/usr/bin/gmcs || die "emake failed"
}

# @FUNCTION: gtk-sharp3-module_src_install
# @DESCRIPTION:
# Installs the module. Fixes up lib paths so they're multilib-safe.
# Gets rid of .la files.
# Is exported.
gtk-sharp3-module_src_install() {
	cd "${S}/${GTK_SHARP_MODULE_DIR}"
	emake DESTDIR="${D}" install || die "emake install failed"
	mono_multilib_comply
	find "${D}" -type f -name '*.la' -exec rm -rf '{}' '+' || die "la removal failed"
	[[ ${GTK_SHARP_MODULE} != "gio" ]] && ( find "${D}" -type f -name 'gapi.xsd' -exec rm -rf '{}' '+' || die "removing failed" )
	[[  $(find "${D}" -type f|wc -l) -lt 3 ]] && die "Too few files. This smells like a failed install."
}

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_install
