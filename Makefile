SHELL := /bin/bash
ARCHS = arm64 arm64e
TARGET = iphone:clang:14.4:14.0
SYSROOT = $(THEOS)/sdks/iPhoneOS14.4.sdk
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_LEAN_AND_MEAN = 1

include $(THEOS)/makefiles/common.mk

BUILD_ID = $(shell gdd if=/dev/urandom of=/dev/stdout bs=3 count=1 2>/dev/null | xxd -p -c 65535 | gtr -d '\n')

before-all::
	@env BUILD_ID=$(BUILD_ID) IPHONEOS_DEPLOYMENT_TARGET=14.0 OPT_LEVEL=3 CC_arm64e_apple_ios=/opt/apple-llvm-hikari/bin/clang CC_arm64_apple_ios=/opt/apple-llvm-hikari/bin/clang CFLAGS="-fvisibility=hidden -mllvm --enable-bcfobf -mllvm --enable-strcry" brimstone-processor \
		compile \
		--state .brimstone-state.json \
		--header Sources/LucientC/include/string_table.h \
		--config brimstone.toml \
		--string Assets/Strings/main.plist \
		--string Assets/Strings/info.plist \
		--string Assets/Strings/drm.production.plist \
		--output libbrimstone.a

before-stage::
	@brimstone-processor \
		process \
		--state .brimstone-state.json \
		--code . \
		"$(THEOS_OBJ_DIR)/$(or $($(THEOS_CURRENT_INSTANCE)_BUNDLE_NAME),$(THEOS_CURRENT_INSTANCE))/Lucient.dylib"
	@if [ "$(FINALPACKAGE)" = "1" ]; then\
        echo "Stripping";\
		strip -x -S -T -N "$(THEOS_OBJ_DIR)/$(or $($(THEOS_CURRENT_INSTANCE)_BUNDLE_NAME),$(THEOS_CURRENT_INSTANCE))/Lucient.dylib";\
		\
    fi
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
	@echo "$(shell tput setaf 6)[::]$(shell tput sgr0) Build ID is $(shell tput setaf 2)$(shell tput bold)$(BUILD_ID)$(shell tput sgr0)"

ifdef FINALPACKAGE
TARGET_CC =  /opt/apple-llvm-hikari/bin/clang
TARGET_CXX = /opt/apple-llvm-hikari/bin/clang++
endif

TWEAK_NAME = Lucient

Lucient_FILES = $(shell find Sources/Lucient -name '*.swift') $(shell find Sources/LucientC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Lucient_SWIFTFLAGS = -ISources/LucientC/include
Lucient_CFLAGS = -fobjc-arc -gfull
Lucient_LIBRARIES = brimstone
Lucient_PRIVATE_FRAMEWORKS = AppSupport MediaRemote
Lucient_LDFLAGS = -all_load -L.

ifdef TRIAL
Lucient_CFLAGS += -DTRIAL
Lucient_SWIFTFLAGS += -DTRIAL
endif

ifdef DRM
Lucient_CFLAGS += -DDRM
Lucient_SWIFTFLAGS += -DDRM
endif

ifdef FINALPACKAGE
Lucient_CFLAGS += -fvisibility=hidden -mllvm --enable-bcfobf -mllvm --enable-strcry
SHOULD_STRIP = 0
OPTFLAG = -Oz
SWIFT_OPTFLAG = -O -whole-module-optimization -num-threads 1
else
Lucient_CFLAGS += -DDEBUG
Lucient_SWIFTFLAGS += -DDEBUG
endif

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
