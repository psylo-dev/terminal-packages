TERMUX_PKG_HOMEPAGE=https://github.com/itsaky/jdk21-android
TERMUX_PKG_DESCRIPTION="Java development kit and runtime"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=21.0
TERMUX_PKG_SRCURL=https://github.com/itsaky/jdk21-android/archive/3328b531eb9762acda2b3bd334eb3b25a7214d72.tar.gz
TERMUX_PKG_SHA256=f201a11a5cff9e7efe8eff93e84c835a3c7ead3827e55adb54d85a9dc25ffbf0
TERMUX_PKG_DEPENDS="libiconv, libjpeg-turbo, zlib"
TERMUX_PKG_BUILD_DEPENDS="cups, libandroid-spawn, xorgproto"
# openjdk-21-x is recommended because X11 separation is still very experimental.
TERMUX_PKG_RECOMMENDS="ca-certificates-java, openjdk-21-x, resolv-conf"
TERMUX_PKG_SUGGESTS="cups"
TERMUX_PKG_BREAKS="openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HAS_DEBUG=false

termux_step_post_get_source() {
    boot_jdk_url="https://download.java.net/java/GA/jdk21/fd2272bbf8e04c3dbaee13770090416c/35/GPL/openjdk-21_linux-x64_bin.tar.gz"
    boot_jdk_sha256="a30c454a9bef8f46d5f1bf3122830014a8fbe7ac03b5f8729bc3add4b92a1d0a"
    boot_jdk_archive_path="${TERMUX_PKG_CACHEDIR}/boot-jdk.tar.gz"
    
    termux_download "$boot_jdk_url" "$boot_jdk_archive_path" "$boot_jdk_sha256"
    echo "Extracting Boot JDK..."
    
    echo "$boot_jdk_archive_path"
    tar xf $boot_jdk_archive_path -C $TERMUX_PKG_CACHEDIR
}

termux_step_pre_configure() {
    unset JAVA_HOME
    
    # Provide fake gcc.
    mkdir -p $TERMUX_PKG_SRCDIR/wrappers-bin
	cat <<- EOF > $TERMUX_PKG_SRCDIR/wrappers-bin/android-wrapped-clang
	#!/bin/bash
	name=\$(basename "\$0")
	if [ "\$name" = "android-wrapped-clang" ]; then
		name=gcc
		compiler=$CC
	else
		name=g++
		compiler=$CXX
	fi
	if [ "\$1" = "--version" ]; then
		echo "${TERMUX_HOST_PLATFORM/arm/armv7a}-\${name} (GCC) 4.9 20140827 (prerelease)"
		echo "Copyright (C) 2014 Free Software Foundation, Inc."
		echo "This is free software; see the source for copying conditions.  There is NO"
		echo "warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
		exit 0
	fi
	exec \$compiler "\${@/-fno-var-tracking-assignments/}"
	EOF
    chmod +x $TERMUX_PKG_SRCDIR/wrappers-bin/android-wrapped-clang
    ln -sfr $TERMUX_PKG_SRCDIR/wrappers-bin/android-wrapped-clang \
    $TERMUX_PKG_SRCDIR/wrappers-bin/android-wrapped-clang++
    CC=$TERMUX_PKG_SRCDIR/wrappers-bin/android-wrapped-clang
    CXX=$TERMUX_PKG_SRCDIR/wrappers-bin/android-wrapped-clang++
    
	cat <<- EOF > $TERMUX_STANDALONE_TOOLCHAIN/devkit.info
	DEVKIT_NAME="Android"
	DEVKIT_TOOLCHAIN_PATH="\$DEVKIT_ROOT"
	DEVKIT_SYSROOT="\$DEVKIT_ROOT/sysroot"
	EOF
    
    cp -rT $TERMUX_STANDALONE_TOOLCHAIN/sysroot $TERMUX_PKG_TMPDIR/sysroot
}

termux_step_configure() {
    local jdk_ldflags="-L${TERMUX_PREFIX}/lib -Wl,-rpath=$TERMUX_PREFIX/opt/openjdk/lib -Wl,-rpath=${TERMUX_PREFIX}/lib -Wl,--enable-new-dtags"
    bash ./configure \
    --openjdk-target=$TERMUX_HOST_PLATFORM \
    --with-extra-cflags="$CFLAGS $CPPFLAGS -DLE_STANDALONE -DANDROID -D__TERMUX__=1" \
    --with-extra-cxxflags="$CXXFLAGS $CPPFLAGS -DLE_STANDALONE -DANDROID -D__TERMUX__=1" \
    --with-extra-ldflags="${jdk_ldflags} -Wl,--as-needed -landroid-shmem" \
	--with-boot-jdk="${TERMUX_PKG_CACHEDIR}/jdk-21" \
    --disable-precompiled-headers \
    --disable-warnings-as-errors \
    --enable-option-checking=fatal \
    --with-toolchain-type=gcc \
    --with-jvm-variants=server \
    --with-devkit="$TERMUX_STANDALONE_TOOLCHAIN" \
    --with-debug-level=release \
    --with-cups-include="$TERMUX_PREFIX/include" \
    --with-fontconfig-include="$TERMUX_PREFIX/include" \
    --with-freetype-include="$TERMUX_PREFIX/include/freetype2" \
    --with-freetype-lib="$TERMUX_PREFIX/lib" \
    --with-giflib=system \
    --with-libjpeg=system \
    --with-libpng=system \
    --with-zlib=system \
    --x-includes="$TERMUX_PREFIX/include/X11" \
    --x-libraries="$TERMUX_PREFIX/lib" \
    --with-x="$TERMUX_PREFIX/include/X11" \
    AR="$AR" \
    NM="$NM" \
    OBJCOPY="$OBJCOPY" \
    OBJDUMP="$OBJDUMP" \
    STRIP="$STRIP"
}

termux_step_make() {
    cd build/linux-${TERMUX_ARCH/i686/x86}-server-release
    JAVA_WARNINGS_ARE_ERRORS="" make JOBS=$(nproc --all) images
}

termux_step_make_install() {
    rm -rf $TERMUX_PREFIX/opt/openjdk
    mkdir -p $TERMUX_PREFIX/opt/openjdk
    cp -r build/linux-${TERMUX_ARCH/i686/x86}-server-release/images/jdk/* \
    $TERMUX_PREFIX/opt/openjdk/
    find $TERMUX_PREFIX/opt/openjdk -name "*.debuginfo" -delete
    
    # OpenJDK is not installed into /prefix/bin.
    local i
    for i in $TERMUX_PREFIX/opt/openjdk/bin/*; do
        if [ ! -f "$i" ]; then
            continue
        fi
        ln -sfr "$i" "$TERMUX_PREFIX/bin/$(basename "$i")"
    done
    
    # Link manpages to location accessible by "man".
    mkdir -p $TERMUX_PREFIX/share/man/man1
    for i in $TERMUX_PREFIX/opt/openjdk/man/man1/*; do
        if [ ! -f "$i" ]; then
            continue
        fi
        gzip "$i"
        ln -sfr "${i}.gz" "$TERMUX_PREFIX/share/man/man1/$(basename "$i").gz"
    done
    
    # Dependent projects may need JAVA_HOME.
    mkdir -p $TERMUX_PREFIX/etc/profile.d
    echo "export JAVA_HOME=$TERMUX_PREFIX/opt/openjdk" > \
    $TERMUX_PREFIX/etc/profile.d/java.sh
}
