INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WisdomTreeZsAutoNext

WisdomTreeZsAutoNext_FILES = Tweak.x
WisdomTreeZsAutoNext_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
