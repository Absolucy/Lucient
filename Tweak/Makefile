ARCHS = arm64 arm64e
TARGET = iphone:clang:14.4:14.0
SYSROOT = $(THEOS)/sdks/iPhoneOS14.4.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Lucient

Lucient_FILES = $(shell find Sources/Lucient -name '*.swift') $(shell find Sources/LucientC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Lucient_SWIFTFLAGS = -ISources/LucientC/include
Lucient_CFLAGS = -fobjc-arc
Lucient_PRIVATE_FRAMEWORKS = AppSupport MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk
