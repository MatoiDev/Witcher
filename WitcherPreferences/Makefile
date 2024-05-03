BUNDLE_NAME = WitcherPreferences

# FINALPACKAGE=1
DEBUG=1
THEOS_PACKAGE_SCHEME=rootless

ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
	WitcherPreferences_INSTALL_PATH = /var/jb/Library/PreferenceBundles
    WitcherPreferences_RESOURCES_PATH = /var/jb/Library/PreferenceBundles/WitcherPreferences.bundle
    THEOS_DEVICE_IP = 192.168.1.45
else
    WitcherPreferences_INSTALL_PATH = /Library/PreferenceBundles
    THEOS_DEVICE_IP = 192.168.1.45
endif

WitcherPreferences_FILES  = $(wildcard *.m)
WitcherPreferences_FRAMEWORKS = UIKit
WitcherPreferences_PRIVATE_FRAMEWORKS = Preferences

WitcherPreferences_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk