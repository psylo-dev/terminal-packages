TERMUX_PKG_HOMEPAGE=https://invisible-island.net/diffstat/diffstat.html
TERMUX_PKG_DESCRIPTION="Displays a histogram of changes to a file"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.65
TERMUX_PKG_SRCURL=http://mirrors.lug.mtu.edu/gentoo/distfiles/7e/diffstat-${TERMUX_PKG_VERSION}.tgz
# invisible-mirror.net is not suitable for CI due to bad responsiveness.
#TERMUX_PKG_SRCURL=https://invisible-mirror.net/archives/diffstat/diffstat-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SRCURL=https://invisible-island.net/datafiles/release/diffstat.tar.gz
#TERMUX_PKG_SHA256=23716d3de80fd36a4f6063ab2a59bf50061a19097885bfdee45280024f80c6a5
TERMUX_PKG_SHA256=8cf27424926debcd85921755c3915559288244bd103f62d740dc6b83b557a28a
