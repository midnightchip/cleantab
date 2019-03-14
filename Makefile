include $(THEOS)/makefiles/common.mk

TWEAK_NAME = cleanTab
cleanTab_FILES = Tweak.xm
cleanTab_LIBRARIES = applist

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += cleantabpref
include $(THEOS_MAKE_PATH)/aggregate.mk
