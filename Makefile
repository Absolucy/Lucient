TARGET := iphone:clang:14.4:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

before-all::
	env IPHONEOS_DEPLOYMENT_TARGET=14.0 OPT_LEVEL=3 CC=/opt/apple-llvm-hikari/bin/clang brimstone-processor \
		compile \
		--state .brimstone-state.json \
		--header Sources/LucientC/include/string_table.h \
		--config brimstone.toml \
		--string Assets/Strings/main.plist \
		--string Assets/Strings/drm.production.plist \
		--output libbrimstone.a

TWEAK_NAME = Lucient

Lucient_FILES = $(shell find Sources/Lucient -name '*.swift') $(shell find Sources/LucientC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Lucient_SWIFTFLAGS = -ISources/LucientC/include -DDRM
Lucient_CFLAGS = -fobjc-arc -DDRM -DDEBUG -gfull
Lucient_LIBRARIES = brimstone
Lucient_LDFLAGS = -all_load -L.

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += lucientprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
