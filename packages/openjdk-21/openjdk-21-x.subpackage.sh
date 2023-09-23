TERMUX_SUBPKG_INCLUDE="
opt/openjdk-${TERMUX_PKG_VERSION}/include/jawt.h
opt/openjdk-${TERMUX_PKG_VERSION}/include/linux/jawt_md.h
opt/openjdk-${TERMUX_PKG_VERSION}/jmods/java.desktop.jmod
opt/openjdk-${TERMUX_PKG_VERSION}/lib/libawt_xawt.so
opt/openjdk-${TERMUX_PKG_VERSION}/lib/libfontmanager.so
opt/openjdk-${TERMUX_PKG_VERSION}/lib/libjawt.so
opt/openjdk-${TERMUX_PKG_VERSION}/lib/libsplashscreen.so
"
TERMUX_SUBPKG_DESCRIPTION="Portion of openjdk-21 requiring X11 functionality"
TERMUX_SUBPKG_DEPENDS="fontconfig, freetype, giflib, libandroid-shmem, libpng, libx11, libxext, libxi, libxrandr, libxrender, libxt, libxtst"
TERMUX_SUBPKG_REPLACES="openjdk-17-x"
