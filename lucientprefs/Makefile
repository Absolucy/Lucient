TARGET := iphone:clang:latest:12.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LucientPrefs

LucientPrefs_FILES = $(shell find Sources/LucientPrefs -name '*.swift') $(shell find Sources/LucientPrefsC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
LucientPrefs_INSTALL_PATH = /Library/PreferenceBundles
LucientPrefs_SWIFTFLAGS = -ISources/LucientPrefsC/include
LucientPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
