#!/bin/bash
set -e
# Setup environment
source scripts/env.sh
# Compile Brimstone
env CC=/opt/apple-llvm-hikari/bin/clang CFLAGS="-mllvm --enable-bcfobf -mllvm --enable-strcry" brimstone-processor \
	compile \
	--state "$TARGET_DIR/.brimstone-state.json" \
	--config config.toml \
	--string res/strings/main.plist \
	--string res/strings/drm.production.plist \
	--output "$TARGET_DIR/libbrimstone.a"

# Copy files to tmpdir
cp -R Makefile "$TARGET_DIR"
cp -R Package.swift "$TARGET_DIR"
cp -R Sources "$TARGET_DIR"
cp -R Lucient.plist "$TARGET_DIR"
cp -R Lucientprefs "$TARGET_DIR"
# Run preprocessor on source
brimstone-processor \
	preprocess \
	--state "$TARGET_DIR/.brimstone-state.json" \
	--code "$TARGET_DIR"
# Compile our temporary directory
cd "$TARGET_DIR"
gmake stage FINALPACKAGE=1 DRM=1 SHOULD_STRIP=0
cd "$INITIAL_DIR"
# Run the checksuminator; then strip and re-sign
brimstone-processor \
	process \
	--state "$TARGET_DIR/.brimstone-state.json" \
	--code "$TARGET_DIR" \
	"$TARGET_DIR/.theos/_/Library/MobileSubstrate/DynamicLibraries/Lucient.dylib"
strip -x -S -T -N "$TARGET_DIR/.theos/_/Library/MobileSubstrate/DynamicLibraries/Lucient.dylib"
ldid2 -S "$TARGET_DIR/.theos/_/Library/MobileSubstrate/DynamicLibraries/Lucient.dylib"
# Run the checksuminator on the prefs bundle; then strip and re-sign
brimstone-processor \
	process \
	--state "$TARGET_DIR/.brimstone-state.json"  \
	--code "$TARGET_DIR" \
	"$TARGET_DIR/.theos/_/Library/PreferenceBundles/LucientPrefs.bundle/LucientPrefs"
strip -x -S -T -N "$TARGET_DIR/.theos/_/Library/PreferenceBundles/LucientPrefs.bundle/LucientPrefs"
ldid2 -S "$TARGET_DIR/.theos/_/Library/PreferenceBundles/LucientPrefs.bundle/LucientPrefs"
# Pack the deb
mkdir -p "$TARGET_DIR/.theos/_/DEBIAN"
cp -f deb/control.full "$TARGET_DIR/.theos/_/DEBIAN/control"
dpkg-deb -Zxz -b "$TARGET_DIR/.theos/_" target/me.aspenuwu.Lucient_"$VERSION"_iphoneos-arm64.deb