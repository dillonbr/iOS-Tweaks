TARGET := iphone:clang:latest:12.0
INSTALL_TARGET_PROCESSES = Gympass
GO_EASY_ON_ME = 1


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GympassJBBypass
GympassJBBypass_FILES = Tweak.xm
GympassJBBypass_CFLAGS = -fobjc-arc
GympassJBBypass_FRAMEWORKS = UIKit Foundation
ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
