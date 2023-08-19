TERMUX_PKG_HOMEPAGE=https://androidide.com/
TERMUX_PKG_DESCRIPTION="Basic system tools for AndroidIDE"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@itsaky"
TERMUX_PKG_VERSION=0.05
TERMUX_PKG_SRCURL=https://github.com/AndroidIDEOfficial/androidide-tools/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e7c7fd693dcbc402503d0eb147e3f06d6ef8d9dbd1fde660f7afe694d1093f12
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_ESSENTIAL=true

# Required by the tools included
TERMUX_PKG_DEPENDS="libcurl, jq, nano, wget"
TERMUX_PKG_RECOMMENDS="openjdk-17"

termux_step_make_install() {
    for script in idesetup ideenv; do
        install -Dm700 $TERMUX_PKG_SRCDIR/scripts/$script $TERMUX_PREFIX/bin/$script
    done
}
