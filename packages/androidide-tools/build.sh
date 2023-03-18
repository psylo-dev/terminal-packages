TERMUX_PKG_HOMEPAGE=https://androidide.com/
TERMUX_PKG_DESCRIPTION="Basic system tools for AndroidIDE"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@itsaky"
TERMUX_PKG_VERSION=0.03
TERMUX_PKG_SRCURL=https://github.com/AndroidIDEOfficial/androidide-tools/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=181254af037bc4a3afce4aa0c6e59fdffb78d111493da6ee20e03df09651ed37
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
