include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = cleantabpref
cleantabpref_FILES = CTPRootListController.m CTPHeaderCell.m
cleantabpref_INSTALL_PATH = /Library/PreferenceBundles
cleantabpref_FRAMEWORKS = UIKit
cleantabpref_PRIVATE_FRAMEWORKS = Preferences
cleantabpref_LIBRARIES = applist
cleantabpref_EXTRA_FRAMEWORKS += Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/cleantabpref.plist$(ECHO_END)
