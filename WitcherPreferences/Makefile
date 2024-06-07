BUNDLE_NAME = WitcherPreferences

FINALPACKAGE=1
# DEBUG=1
THEOS_PACKAGE_SCHEME=rootless

WitcherPreferences_FILES  = $(wildcard *.m) $(wildcard UI/Cells/PowerCell/*.m) $(wildcard UI/Cells/PowerCell/Button/*.m) $(wildcard UI/Cells/AuthorCell/*.m) $(wildcard UI/Cells/HeaderCell/*.m) $(wildcard UI/Cells/AuthorCell/GithubStatsParser/*.m) $(wildcard UI/Cells/SwitchCell/*.m) $(wildcard UI/Cells/SwitchCell/Switch/*.m) $(wildcard UI/Cells/ColorPickerCell/*.m)  $(wildcard 3rdPartyLibs/Lottie/*.m) 
WitcherPreferences_FRAMEWORKS = UIKit CoreText
WitcherPreferences_PRIVATE_FRAMEWORKS = Preferences

WitcherPreferences_INSTALL_PATH = /Library/PreferenceBundles
WitcherPreferences_RESOURCES_PATH = /Library/PreferenceBundles/WitcherPreferences.bundle

WitcherPreferences_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk