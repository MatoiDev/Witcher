export ARCHS = arm64 arm64e
export TARGET = iphone:clang:14.6
export SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk

FINALPACKAGE=1
# DEBUG=1
THEOS_PACKAGE_SCHEME=rootless


ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
    THEOS_DEVICE_IP = 192.168.1.45
else
    THEOS_DEVICE_IP = 192.168.1.39
endif

TWEAK_NAME = Witcher

Witcher_FILES = Witcher.x $(wildcard UI/ApplicationLayoutContainer/*.m) $(wildcard UI/ApplicationLayoutStruct/*.m) $(wildcard UI/Router/*.m) $(wildcard UI/Router/Cell/*.m) $(wildcard Extensions/*.m)
Witcher_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
Witcher_FRAMEWORKS = UIKit QuartzCore CoreFoundation
Witcher_PRIVATE_FRAMEWORKS = SpringBoardServices

SUBPROJECTS += witcherpreferences

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

after-stage::
	find . -name ".DS_STORE" -delete
after-install::
	install.exec "killall -HUP SpringBoard"

