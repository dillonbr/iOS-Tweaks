TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = YouTube
GO_EASY_ON_ME = 1


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YouTubeReborn
YouTubeReborn_FILES = Tweak.xm $(shell find Controllers -name '*.m') $(shell find XCDYouTubeKit -name '*.m') $(shell find AFNetworking -name '*.m')
YouTubeReborn_CFLAGS = -fobjc-arc
YouTubeReborn_FRAMEWORKS = UIKit Foundation AVFoundation AVKit
ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
