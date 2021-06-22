ARCHS = arm64 arm64e
TARGET = iphone:clang:14.4:14.0
SYSROOT = $(THEOS)/sdks/iPhoneOS14.4.sdk
#INSTALL_TARGET_PROCESSES = SpringBoard
INSTALL_TARGET_PROCESSES = Preferences
THEOS_LEAN_AND_MEAN = 1

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

before-stage::
	brimstone-processor \
		process \
		--state .brimstone-state.json \
		--code . \
		"$(THEOS_OBJ_DIR)/$(or $($(THEOS_CURRENT_INSTANCE)_BUNDLE_NAME),$(THEOS_CURRENT_INSTANCE))/Lucient.dylib"
	ldid2 -S "$(THEOS_OBJ_DIR)/$(or $($(THEOS_CURRENT_INSTANCE)_BUNDLE_NAME),$(THEOS_CURRENT_INSTANCE))/Lucient.dylib"

after-stage::
	cp -R Assets/Layout/* "$(THEOS_STAGING_DIR)"
	mv "$(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/Lucient.dylib" "$(THEOS_STAGING_DIR)/Library/Lucy/Lucient.bundle/Lucient.dylib"
	rm "$(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/Lucient.plist"
	mv "$(THEOS_STAGING_DIR)/Library/PreferenceBundles/LucientPrefs.bundle" "$(THEOS_STAGING_DIR)/Library/Lucy/LucientPrefs.bundle"
	mv "$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/LucientPrefs.plist" "$(THEOS_STAGING_DIR)/Library/Lucy/LucientPrefs.bundle/LucientPrefs.plist"
	ln -s /Library/Lucy/Lucient.bundle/Lucient.dylib "$(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/Lucient.dylib"
	ln -s /Library/Lucy/Lucient.bundle/Info.plist "$(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/Lucient.plist"
	ln -s /Library/Lucy/LucientPrefs.bundle "$(THEOS_STAGING_DIR)/Library/PreferenceBundles/LucientPrefs.bundle"
	ln -s /Library/Lucy/LucientPrefs.bundle/LucientPrefs.plist "$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/LucientPrefs.plist"


TWEAK_NAME = Lucient

Lucient_FILES = $(shell find Sources/Lucient -name '*.swift') $(shell find Sources/LucientC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Lucient_SWIFTFLAGS = -ISources/LucientC/include -DDRM
Lucient_CFLAGS = -fobjc-arc -DDRM -gfull
Lucient_LIBRARIES = brimstone
Lucient_PRIVATE_FRAMEWORKS = AppSupport MediaRemote
Lucient_LDFLAGS = -all_load -L.

ifndef FINALPACKAGE
Lucient_CFLAGS				+= -DDEBUG
Lucient_SWIFTFLAGS	     	+= -DDEBUG
endif

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
