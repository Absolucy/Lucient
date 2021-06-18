#!/bin/bash
set -e
# Setup environment
source scripts/env.sh
# compile
gmake stage DEBUG=1 DRM=1
cd "$INITIAL_DIR"
# Run the checksuminator; then strip and re-sign
brimstone-processor \
	process \
	--state "$INITIAL_DIR/.brimstone-state.json" \
	--code "$INITIAL_DIR" \
	"$INITIAL_DIR/.theos/_/Library/MobileSubstrate/DynamicLibraries/Lucient.dylib"
ldid2 -S "$INITIAL_DIR/.theos/_/Library/MobileSubstrate/DynamicLibraries/Lucient.dylib"
# Pack the deb
mkdir -p "$INITIAL_DIR/.theos/_/DEBIAN"
cp -f deb/control.full "$INITIAL_DIR/.theos/_/DEBIAN/control"
dpkg-deb -Zxz -b "$INITIAL_DIR/.theos/_" target/me.aspenuwu.lucient_"$VERSION"+debug_iphoneos-arm64.deb
