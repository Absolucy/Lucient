export ARCHS = arm64 arm64e
export TARGET = iphone:clang:14.4:14.0
export SYSROOT = $(THEOS)/sdks/iPhoneOS14.4.sdk

include $(THEOS)/makefiles/common.mk

before-all::
	env IPHONEOS_DEPLOYMENT_TARGET=14.0 OPT_LEVEL=3 CC=/opt/apple-llvm-hikari/bin/clang brimstone-processor \
		compile \
		--state .brimstone-state.json \
		--header Sources/LucientC/include/string_table.h \
		--config brimstone.toml \
		--string ../Assets/Strings/main.plist \
		--string ../Assets/Strings/drm.production.plist \
		--output libbrimstone.a

before-stage::
	brimstone-processor \
		process \
		--state .brimstone-state.json \
		--code . \
		"$(THEOS_OBJ_DIR)/$(or $($(THEOS_CURRENT_INSTANCE)_BUNDLE_NAME),$(THEOS_CURRENT_INSTANCE))/Lucient.dylib"
	ldid2 -S "$(THEOS_OBJ_DIR)/$(or $($(THEOS_CURRENT_INSTANCE)_BUNDLE_NAME),$(THEOS_CURRENT_INSTANCE))/Lucient.dylib"

TWEAK_NAME = Lucient

Lucient_FILES = $(shell find Sources/Lucient -name '*.swift') $(shell find Sources/LucientC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Lucient_SWIFTFLAGS = -ISources/LucientC/include -DDRM
Lucient_CFLAGS = -fobjc-arc -DDRM -DDEBUG -gfull
Lucient_LIBRARIES = brimstone
Lucient_PRIVATE_FRAMEWORKS = MediaRemote
Lucient_LDFLAGS = -all_load -L.

include $(THEOS_MAKE_PATH)/tweak.mk
