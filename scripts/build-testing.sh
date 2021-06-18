#!/bin/bash
set -e
# Setup environment
source scripts/env.sh
# compile
gmake DEBUG=1 DRM=1
cd "$INITIAL_DIR"
# Set up our real folder structule
cp -r Assets/Layout/* "$TARGET_DIR"
cp .theos/obj/debug/Lucient.dylib "$TARGET_DIR/Library/Lucy/Lucient.bundle/Lucient.dylib"
cp -r .theos/obj/debug/LucientPrefs.bundle "$TARGET_DIR/Library/Lucy"
cp lucientprefs/layout/Library/PreferenceLoader/Preferences/LucientPrefs.plist "$TARGET_DIR/Library/Lucy/LucientPrefs.bundle/LucientPrefs.plist"
mkdir -p "$TARGET_DIR/Library/MobileSubstrate/DynamicLibraries" "$TARGET_DIR/Library/PreferenceBundles" "$TARGET_DIR/Library/PreferenceLoader/Preferences"
ln -s /Library/Lucy/Lucient.bundle/Lucient.dylib "$TARGET_DIR/Library/MobileSubstrate/DynamicLibraries/Lucient.dylib"
ln -s /Library/Lucy/Lucient.bundle/Info.plist "$TARGET_DIR/Library/MobileSubstrate/DynamicLibraries/Lucient.plist"
ln -s /Library/Lucy/LucientPrefs.bundle "$TARGET_DIR/Library/PreferenceBundles/LucientPrefs.bundle"
ln -s /Library/Lucy/LucientPrefs.bundle/LucientPrefs.plist "$TARGET_DIR/Library/PreferenceLoader/Preferences/LucientPrefs.plist"
# Run the checksuminator; then strip and re-sign
brimstone-processor \
	process \
	--state "$INITIAL_DIR/.brimstone-state.json" \
	--code "$INITIAL_DIR" \
	"$TARGET_DIR/Library/Lucy/Lucient.bundle/Lucient.dylib"
ldid2 -S "$TARGET_DIR/Library/Lucy/Lucient.bundle/Lucient.dylib"
# Pack the deb
mkdir -p "$TARGET_DIR/DEBIAN"
cp deb/control.full "$TARGET_DIR/DEBIAN/control"
dpkg-deb -Zxz -b "$TARGET_DIR" target/moe.absolucy.lucient_"$VERSION"+debug_iphoneos-arm64.deb
