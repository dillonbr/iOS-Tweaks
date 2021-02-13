TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = YouTubeMusic
GO_EASY_ON_ME = 1


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YouTubeMusicReborn
YouTubeMusicReborn_FILES = Tweak.xm $(shell find Controllers -name '*.m')
YouTubeMusicReborn_CFLAGS = -fobjc-arc
YouTubeMusicReborn_FRAMEWORKS = UIKit Foundation
ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
