export SHELL := /bin/bash
export ARCHS = arm64 arm64e
export TARGET = iphone:clang:14.4:14.0
export SYSROOT = $(THEOS)/sdks/iPhoneOS14.4.sdk
export INSTALL_TARGET_PROCESSES = SpringBoard
export THEOS_LEAN_AND_MEAN = 1
export GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

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
	rm -rf .theos/Lucient.dSYM
	dsymutil "$(THEOS_STAGING_DIR)/Library/Lucy/Lucient.bundle/Lucient.dylib" -o .theos/Lucient.dSYM
	@find "$(THEOS_STAGING_DIR)" -name .DS_Store -type f -delete
	@echo "$(shell tput setaf 6)[::]$(shell tput sgr0) Build ID is $(shell tput setaf 2)$(shell tput bold)$(BUILD_ID)$(shell tput sgr0)"


SUBPROJECTS += Tweak Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
