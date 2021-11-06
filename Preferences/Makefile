include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LucientPrefs

LucientPrefs_FILES = $(shell find Sources/LucientPrefs -name '*.swift') \
	$(shell find ../Tweak/Sources/Lucient/Settings -name '*.swift')  \
	$(shell find ../Tweak/Sources/Lucient/Extensions -name '*.swift')  \
	$(shell find Sources/LucientPrefsC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
LucientPrefs_INSTALL_PATH = /Library/PreferenceBundles
LucientPrefs_SWIFTFLAGS = -ISources/LucientPrefsC/include
LucientPrefs_CFLAGS = -fobjc-arc
LucientPrefs_PRIVATE_FRAMEWORKS = Preferences MobileCoreServices

include $(THEOS_MAKE_PATH)/bundle.mk
