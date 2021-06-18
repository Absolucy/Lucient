TARGET := iphone:clang:14.4:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LucientPrefs

LucientPrefs_FILES = $(shell find Sources/LucientPrefs -name '*.swift') $(shell find Sources/LucientPrefsC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
LucientPrefs_INSTALL_PATH = /Library/PreferenceBundles
LucientPrefs_SWIFTFLAGS = -ISources/LucientPrefsC/include
LucientPrefs_CFLAGS = -fobjc-arc
LucientPrefs_EXTRA_FRAMEWORKS += Cephei
LucientPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk
