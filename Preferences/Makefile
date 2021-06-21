export ARCHS = arm64 arm64e
export TARGET = iphone:clang:14.4:14.0
export SYSROOT = $(THEOS)/sdks/iPhoneOS14.4.sdk

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LucientPrefs

INSTALL_TARGET_PROCESSES = Preferences

LucientPrefs_FILES = $(shell find Sources/LucientPrefs -name '*.swift') $(shell find Sources/LucientPrefsC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
LucientPrefs_INSTALL_PATH = /Library/PreferenceBundles
LucientPrefs_SWIFTFLAGS = -ISources/LucientPrefsC/include
LucientPrefs_CFLAGS = -fobjc-arc
LucientPrefs_PRIVATE_FRAMEWORKS = Preferences MobileCoreServices

include $(THEOS_MAKE_PATH)/bundle.mk
