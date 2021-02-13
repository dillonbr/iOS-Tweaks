#import <XCDYouTubeKit/XCDYouTubeKit.h>
#import <AFNetworking/AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <Photos/Photos.h>
#import <AVKit/AVKit.h>
#import <UIKit/UIKit.h>
#import "Controllers/RootOptionsController.h"
#import "Tweak.h"

%hook YTAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *actualVersion = [info objectForKey:@"CFBundleShortVersionString"];
    NSString* requiredVersion = @"15.47.0";
    if ([requiredVersion compare:actualVersion options:NSNumericSearch] == NSOrderedDescending) {
        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [UIViewController new];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:[NSString stringWithFormat:@"Your YouTube version (%@) is to low to support YouTube Reborn, please update YouTube to version 15.47.0+ in order to use YouTube Reborn", actualVersion] preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"Close App" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            alertWindow.hidden = YES;
            UIApplication *app = [UIApplication sharedApplication];
            [app performSelector:@selector(suspend)];
            [NSThread sleepForTimeInterval:2.0];
            exit(0);
        }]];

        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    } else {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ytRebornFirstTimeAlertViewShownOnce"] == NO) {
            UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindow.rootViewController = [UIViewController new];
            alertWindow.windowLevel = UIWindowLevelAlert + 1;

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"YouTube Reborn" message:@"\nWelcome To YouTube Reborn v2 \n\nYou can access the new preferences by pressing on the 'OP' button in the top left corner of yt, next to the logo" preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"Thank You" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                alertWindow.hidden = YES;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ytRebornFirstTimeAlertViewShownOnce"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }]];

            [alertWindow makeKeyAndVisible];
            [alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }
    NSLog(@"App Loaded Successfully");
    return %orig;
}
%end

YTLocalPlaybackController *playingVideoID;

%hook YTLocalPlaybackController
- (NSString *)currentVideoID {
    NSString *result = %orig;
    playingVideoID = self;
    NSLog(@"currentVideoIDLocal: %@", result);
    return result;
}
%end

%hook YTPlayerViewController
- (NSString *)currentVideoID {
    NSString *result = %orig;
    NSLog(@"currentVideoIDPlayer: %@", result);
    return result;
}
%end

YTMainAppVideoPlayerOverlayViewController *resultOut;

%hook YTMainAppVideoPlayerOverlayViewController
- (CGFloat)mediaTime {
    CGFloat myFloat = %orig;
    NSString *result = [NSString stringWithFormat: @"%f", myFloat];
    NSLog(@"Time: %@", result);
    resultOut = self;
    return myFloat;
}
%end

%hook YTAdsInnerTubeContextDecorator
- (void)decorateContext:(id)arg1 {
}
%end

%group gBackgroundPlayback
%hook YTIPlayerResponse
- (BOOL)isPlayableInBackground {
    return 1;
}
%end
%hook YTSingleVideo
- (BOOL)isPlayableInBackground {
    return 1;
}
%end
%hook YTSingleVideoMediaData
- (BOOL)isPlayableInBackground {
    return 1;
}
%end
%hook YTPlaybackData
- (BOOL)isPlayableInBackground {
    return 1;
}
%end
%hook YTIPlayabilityStatus
- (BOOL)isPlayableInBackground {
    return 1;
}
%end
%hook YTPlaybackBackgroundTaskController
- (BOOL)isContentPlayableInBackground {
    return 1;
}
- (void)setContentPlayableInBackground:(BOOL)arg1 {
    arg1 = 1;
	%orig;
}
%end
%end

%group gNoDownloadButton
%hook YTTransferButton
- (void)setVisible:(BOOL)arg1 dimmed:(BOOL)arg2 {
    arg1 = 0;
	%orig;
}
%end
%end

%group gNoCommentsSection
%hook YTCommentSectionControllerBuilder
- (void)loadSectionController:(id)arg1 withModel:(id)arg2 {
} 
%end
%end

%group gNoCastButton
%hook YTSettings
- (BOOL)disableMDXDeviceDiscovery {
    return 1;
} 
%end
%hook YTRightNavigationButtons
- (void)layoutSubviews {
	%orig();
	if(![[self MDXButton] isHidden]) [[self MDXButton] setHidden: YES];
}
%end
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	if(![[self playbackRouteButton] isHidden]) [[self playbackRouteButton] setHidden: YES];
}
%end
%end

%group gNoNotificationButton
%hook YTNotificationPreferenceToggleButton
- (void)setHidden:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%hook YTNotificationMultiToggleButton
- (void)setHidden:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%hook YTRightNavigationButtons
- (void)layoutSubviews {
	%orig();
	if(![[self notificationButton] isHidden]) [[self notificationButton] setHidden: YES];
}
%end
%end

%group gAllowHDOnCellularData
%hook YTUserDefaults
- (BOOL)disableHDOnCellular {
	return 0;
}
- (void)setDisableHDOnCellular:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTSettings
- (BOOL)disableHDOnCellular {
	return 0;
}
- (void)setDisableHDOnCellular:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%end

%group gShowStatusBarInOverlay
%hook YTSettings
- (BOOL)showStatusBarWithOverlay {
    return 1;
}
%end
%end

%group gDisableRelatedVideosInOverlay
%hook YTRelatedVideosViewController
- (BOOL)isEnabled {
    return 0;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = 0;
	%orig;
}
%end
%hook YTFullscreenEngagementOverlayView
- (BOOL)isEnabled {
    return 0;
} 
- (void)setEnabled:(BOOL)arg1 {
    arg1 = 0;
    %orig;
} 
%end
%hook YTFullscreenEngagementOverlayController
- (BOOL)isEnabled {
    return 0;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayView
- (void)setInfoCardButtonHidden:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
- (void)setInfoCardButtonVisible:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayViewController
- (void)adjustPlayerBarPositionForRelatedVideos {
}
%end
%end

%group gDisableVideoEndscreenPopups
%hook YTCreatorEndscreenView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%end

%group gDisableYouTubeKidsPopup
%hook YTWatchMetadataAppPromoCell
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%hook YTHUDMessageView
- (id)initWithMessage:(id)arg1 dismissHandler:(id)arg2 {
    return NULL;
}
%end
%end

%group gDisableAgeRestriction
%hook YTUserProfile
- (BOOL)hasLegalAge {
	return 1;
}
%end
%hook YTVideo
- (BOOL)isAdultContent {
    return 0;
} 
%end
%hook YTSettings
- (BOOL)isAdultContentConfirmed {
	return 1;
}
- (void)setAdultContentConfirmed:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%hook YTUserDefaults
- (BOOL)isAdultContentConfirmed {
	return 1;
}
- (void)setAdultContentConfirmed:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%hook YTPlayerRequestFactory
- (BOOL)adultContentConfirmed {
	return 1;
}
%end
%hook YTIdentityState
- (BOOL)isChild {
	return 0;
}
- (BOOL)isAdult {
	return 1;
}
%end
%hook YTIAccountItemRenderer
- (BOOL)isChild {
	return 0;
}
- (BOOL)isAdult {
	return 1;
}
%end
%hook YTIPlayabilityStatus
- (BOOL)isKoreanAgeVerificationRequired {
    return 0;
}
- (BOOL)isAgeCheckRequired {
    return 0;
}
- (BOOL)isContentCheckRequired {
    return 0;
}
%end
%end

%group gDisableVoiceSearch
%hook YTSearchTextField
- (void)setVoiceSearchEnabled:(BOOL)arg1 {
    arg1 = 0;
	%orig;
}
%end
%end

%group gDisableHints
%hook YTSettings
- (BOOL)areHintsDisabled {
	return 1;
}
- (void)setHintsDisabled:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%hook YTUserDefaults
- (BOOL)areHintsDisabled {
	return 1;
}
- (void)setHintsDisabled:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%end

%group gHideExploreTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView2").hidden = YES;
}
- (YTPivotBarItemView *)itemView2 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideUploadTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView3").hidden = YES;
}
- (YTPivotBarItemView *)itemView3 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideSubscriptionsTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView4").hidden = YES;
}
- (YTPivotBarItemView *)itemView4 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideLibraryTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView5").hidden = YES;
}
- (YTPivotBarItemView *)itemView5 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gDisableDoubleTapToSkip
%hook YTDoubleTapToSeekController
- (void)enableDoubleTapToSeek:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
- (void)showDoubleTapToSeekEducationView:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTSettings
- (BOOL)doubleTapToSeekEnabled {
    return 0;
}
%end
%end

%group gNoTopicsSection
%hook YTMySubsFilterHeaderViewController
- (id)loadChipFilterFromModel:(id)arg1 {
    return NULL;
}
%end
%end

%group gHideOverlayDarkBackground
%hook YTMainAppVideoPlayerOverlayView
- (void)setBackgroundVisible:(BOOL)arg1 {
    arg1 = 0;
	%orig;
}
%end
%end

%group gAlwaysShowPlayerBar
%hook YTPlayerBarController
- (void)setPlayerViewLayout:(int)arg1 {
    arg1 = 2;
    %orig;
} 
%end
%hook YTRelatedVideosViewController
- (BOOL)isEnabled {
    return 0;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = 0;
	%orig;
}
%end
%hook YTFullscreenEngagementOverlayView
- (BOOL)isEnabled {
    return 0;
} 
- (void)setEnabled:(BOOL)arg1 {
    arg1 = 0;
    %orig;
} 
%end
%hook YTFullscreenEngagementOverlayController
- (BOOL)isEnabled {
    return 0;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayView
- (void)setInfoCardButtonHidden:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
- (void)setInfoCardButtonVisible:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayViewController
- (void)adjustPlayerBarPositionForRelatedVideos {
}
%end
%end

%group gEnableiPadStyleOniPhone
%hook UIDevice
- (long long)userInterfaceIdiom {
    return 1;
} 
%end
%hook UIStatusBarStyleAttributes
- (long long)idiom {
    return 0;
} 
%end
%hook UIKBTree
- (long long)nativeIdiom {
    return 0;
} 
%end
%hook UIKBRenderer
- (long long)assetIdiom {
    return 0;
} 
%end
%end

%group gHidePreviousAndNextButtonInOverlay
%hook YTMainAppSkipVideoButton
- (void)layoutSubviews {
	%orig();
	if(![[self imageView] isHidden]) [[self imageView] setHidden: YES];
}
- (BOOL)isHidden {
	return 1;
}
%end
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTMainAppControlsOverlayView *>(self, "_previousButton").hidden = YES;
	MSHookIvar<YTMainAppControlsOverlayView *>(self, "_nextButton").hidden = YES;
}
%end
%end

%group gDisableVideoAutoPlay
%hook YTPlaybackConfig
- (void)setStartPlayback:(BOOL)arg1 {
	arg1 = 0;
	%orig;
}
%end
%end

%group gEnableOledDarkMode
%hook UIView
- (void)setBackgroundColor:(UIColor *)color {

    UIColor *selectedColour = [UIColor blackColor];

	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTPivotBarView")])
        color = selectedColour;
	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTLinkCell")])
        color = selectedColour;
	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTAccountHeaderView")])
        color = selectedColour;
	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTFeedHeaderView")])
        color = selectedColour;
	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTSearchView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTPlaylistHeaderView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTSlideForActionsView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCollectionView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTAsyncCollectionView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCollectionSeparatorView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTDrawerAvatarCell")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTChipCloudCell")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTEditSheetControllerHeader")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCommentsHeaderView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTEngagementPanelView")])
        color = selectedColour;
    %orig(color);
}
- (void)layoutSubviews {
    %orig();
    if([self.nextResponder isKindOfClass:NSClassFromString(@"_ASDisplayView")])
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
}
%end
%hook YTCollectionView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];

    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatTickerCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } else {
        color = selectedColour;
    }
    %orig;
} 
%end
%hook YTAsyncCollectionView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];

    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCollectionViewController")]) {
        color = selectedColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTInnerTubeCollectionViewController")]) {
        color = selectedColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTRelatedVideosCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTFullscreenMetadataHighlightsCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHAsyncLiveChatCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTAppCollectionViewController")]) {
        color = selectedColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTWatchNextResultsViewController")]) {
        color = selectedColour;
    }
    %orig;
} 
%end
%hook YTVideoView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
} 
%end
%hook YTCollectionSeparatorView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
} 
%end
%hook YTHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
} 
%end
%hook YTChannelListSubMenuView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
} 
%end
%hook YTHorizontalCardListView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
} 
%end
%hook YTPrivacyTosFooterView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
} 
%end
%hook YTNavigationBar
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
- (void)setBarTintColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTSettingsCell
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
} 
%end
%hook YTSearchBoxView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTSearchView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTReelShelfView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTReelShortsShelfItem
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTNGWatchMiniBarView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTChannelSubMenuView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTC4TabbedHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTTabTitlesView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTPlaylistPanelView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTFeedChannelFilterHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook GOODialogView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTInlineSignInView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook GOOTransitionableView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTSlideForActionsView
- (void)layoutSubviews {
    %orig();
    UIColor *selectedColour = [UIColor blackColor];
    MSHookIvar<YTSlideForActionsView *>(self, "_contentView").backgroundColor = selectedColour;
}
%end
%hook YTShareMainView
- (void)layoutSubviews {
    %orig();
    UIColor *selectedColour = [UIColor blackColor];
    MSHookIvar<YTShareMainView *>(self, "_cancelButton").backgroundColor = selectedColour;
}
%end
%hook YTShareTitleView
- (void)setBackgroundColor:(UIColor *)color {
   UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTEngagementPanelHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTPermissionsView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook ELMView
- (void)layoutSubviews {
    %orig();
    UIColor *selectedColour = [UIColor blackColor];
    self.backgroundColor = selectedColour;
}
%end
%hook YTTopAlignedView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
- (void)layoutSubviews {
    %orig();
    UIColor *selectedColour = [UIColor blackColor];
    MSHookIvar<YTTopAlignedView *>(self, "_contentView").backgroundColor = selectedColour;
}
%end
%hook YTReelShelfItemView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTDialogContainerScrollView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTSubheaderContainerView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTCreateCommentAccessoryView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTCreateCommentTextView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTChannelListSubMenuAvatarView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTCommentView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = [UIColor blackColor];
    color = selectedColour;
    %orig;
}
%end
%hook YTEngagementPanelView
- (void)layoutSubviews {
    %orig();
    UIColor *selectedColour = [UIColor blackColor];
    MSHookIvar<YTEngagementPanelView *>(self, "_resizeHandleView").backgroundColor = selectedColour;
    MSHookIvar<YTEngagementPanelView *>(self, "_resizeHandleBackgroundScrim").backgroundColor = selectedColour;
}
%end
%hook NIAttributedLabel
- (void)setBackgroundColor:(UIColor *)color {
    color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    %orig;
}
%end
%hook YTSearchSuggestionCollectionViewCell
- (void)updateColors {
} 
%end
%end

%group gColourOptions
%hook UIView
- (void)setBackgroundColor:(UIColor *)color {

    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];

	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTPivotBarView")])
        color = selectedColour;
	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTLinkCell")])
        color = selectedColour;
	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTAccountHeaderView")])
        color = selectedColour;
	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTFeedHeaderView")])
        color = selectedColour;
	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTSearchView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTPlaylistHeaderView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTSlideForActionsView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCollectionView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTAsyncCollectionView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCollectionSeparatorView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTDrawerAvatarCell")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTChipCloudCell")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTEditSheetControllerHeader")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCommentsHeaderView")])
        color = selectedColour;
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTEngagementPanelView")])
        color = selectedColour;
    %orig(color);
}
- (void)layoutSubviews {
    %orig();
    if([self.nextResponder isKindOfClass:NSClassFromString(@"_ASDisplayView")])
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
}
%end
%hook YTCollectionView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];

    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatTickerCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } else {
        color = selectedColour;
    }
    %orig;
} 
%end
%hook YTAsyncCollectionView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];

    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCollectionViewController")]) {
        color = selectedColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTInnerTubeCollectionViewController")]) {
        color = selectedColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTRelatedVideosCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTFullscreenMetadataHighlightsCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHAsyncLiveChatCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTAppCollectionViewController")]) {
        color = selectedColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTWatchNextResultsViewController")]) {
        color = selectedColour;
    }
    %orig;
} 
%end
%hook YTVideoView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
} 
%end
%hook YTCollectionSeparatorView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
} 
%end
%hook YTHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
} 
%end
%hook YTChannelListSubMenuView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
} 
%end
%hook YTHorizontalCardListView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
} 
%end
%hook YTPrivacyTosFooterView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
} 
%end
%hook YTNavigationBar
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
- (void)setBarTintColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTSettingsCell
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
} 
%end
%hook YTSearchBoxView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTSearchView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTReelShelfView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTReelShortsShelfItem
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTNGWatchMiniBarView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTChannelSubMenuView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTC4TabbedHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTTabTitlesView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTPlaylistPanelView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTFeedChannelFilterHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook GOODialogView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTInlineSignInView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook GOOTransitionableView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTSlideForActionsView
- (void)layoutSubviews {
    %orig();
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    MSHookIvar<YTSlideForActionsView *>(self, "_contentView").backgroundColor = selectedColour;
}
%end
%hook YTShareMainView
- (void)layoutSubviews {
    %orig();
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    MSHookIvar<YTShareMainView *>(self, "_cancelButton").backgroundColor = selectedColour;
}
%end
%hook YTShareTitleView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTEngagementPanelHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTPermissionsView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook ELMView
- (void)layoutSubviews {
    %orig();
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    self.backgroundColor = selectedColour;
}
%end
%hook YTTopAlignedView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
- (void)layoutSubviews {
    %orig();
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    MSHookIvar<YTTopAlignedView *>(self, "_contentView").backgroundColor = selectedColour;
}
%end
%hook YTReelShelfItemView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTDialogContainerScrollView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTSubheaderContainerView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTCreateCommentAccessoryView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTCreateCommentTextView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTChannelListSubMenuAvatarView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTCommentView
- (void)setBackgroundColor:(UIColor *)color {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    color = selectedColour;
    %orig;
}
%end
%hook YTEngagementPanelView
- (void)layoutSubviews {
    %orig();
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    MSHookIvar<YTEngagementPanelView *>(self, "_resizeHandleView").backgroundColor = selectedColour;
    MSHookIvar<YTEngagementPanelView *>(self, "_resizeHandleBackgroundScrim").backgroundColor = selectedColour;
}
%end
%hook NIAttributedLabel
- (void)setBackgroundColor:(UIColor *)color {
    color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    %orig;
}
%end
%hook YTSearchSuggestionCollectionViewCell
- (void)updateColors {
} 
%end
%end

%group gHideAutoPlaySwitchInOverlay
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	if(![[self autonavSwitch] isHidden]) [[self autonavSwitch] setHidden: YES];
}
%end
%end

%group gHideCaptionsSubtitlesButtonInOverlay
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
    if(![[self closedCaptionsOrSubtitlesButton] isHidden]) [[self closedCaptionsOrSubtitlesButton] setHidden: YES];
}
%end
%end

%group gDisableVideoInfoCards
%hook YTInfoCardTeaserContainerView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
- (BOOL)isVisible {
    return 0;
}
%end
%end

%group gNoSearchButton
%hook YTRightNavigationButtons
- (void)layoutSubviews {
	%orig();
	if(![[self searchButton] isHidden]) [[self searchButton] setHidden: YES];
}
%end
%end

%group gHideTabBarLabels
%hook YTPivotBarItemView
- (void)layoutSubviews {
    %orig();
    [[self navigationButton] setTitle:@"" forState:UIControlStateNormal];
    [[self navigationButton] setTitle:@"" forState:UIControlStateSelected];
}
%end
%end

UIWindow *alertWindowOutOptions;
UIWindow *alertWindowOutVideo;
UIWindow *alertWindowOutOverlay;
UIWindow *alertWindowOutTabBar;
UIWindow *alertWindowOutColour;
UIWindow *alertWindowOutCredits;

%hook YTNavigationBarTitleView
- (void)layoutSubviews {
	%orig();
    UIView *optionsView = MSHookIvar<YTPivotBarItemView *>(self, "_customView");
    [self bringSubviewToFront:optionsView];
    UIImageView *imageView = (UIImageView *)optionsView;
    imageView.contentMode = UIViewContentModeTopLeft;
    CGRect extend = imageView.frame;
    extend.size.width += 15;
    imageView.frame = extend;
    [optionsView setUserInteractionEnabled:YES];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(rootOptionsAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"OP" forState:UIControlStateNormal];
    button.frame = CGRectMake(112, 6.5, 33.0, 35.0);
    [optionsView addSubview:button];
}
%new;
- (void)rootOptionsAction:(id)sender {
    NSLog(@"Options Menu Pressed");
    UIWindow *alertWindowOptions = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindowOptions.rootViewController = [UIViewController new];
    alertWindowOptions.windowLevel = UIWindowLevelAlert + 1;
    alertWindowOutOptions = alertWindowOptions;

    RootOptionsController* rootOptionsController = [[RootOptionsController alloc] init];
    UINavigationController* rootOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:rootOptionsController];
    rootOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

    [alertWindowOptions makeKeyAndVisible];
    [alertWindowOptions.rootViewController presentViewController:rootOptionsControllerView animated:YES completion:nil];
}
%end

%hook RootOptionsController
- (void)viewWillDisappear:(BOOL)animated {
    alertWindowOutOptions.hidden = YES;
    %orig;
}
%end

%hook VideoOptionsController
- (void)viewWillDisappear:(BOOL)animated {
    alertWindowOutVideo.hidden = YES;
    %orig;
}
%end

%hook OverlayOptionsController
- (void)viewWillDisappear:(BOOL)animated {
    alertWindowOutOverlay.hidden = YES;
    %orig;
}
%end

%hook TabBarOptionsController
- (void)viewWillDisappear:(BOOL)animated {
    alertWindowOutTabBar.hidden = YES;
    %orig;
}
%end

%hook ColourOptionsController
- (void)viewWillDisappear:(BOOL)animated {
    alertWindowOutColour.hidden = YES;
    %orig;
}
%end

%hook CreditsOptionsController
- (void)viewWillDisappear:(BOOL)animated {
    alertWindowOutCredits.hidden = YES;
    %orig;
}
%end

UIWindow *alertWindowOutMenu;
UIWindow *alertWindowOutPip;
UIWindow *alertWindowOutPopup;
UIWindow *alertWindowOutDownloading;
UIWindow *alertWindowOutDownloaded;
UIWindow *alertWindowOutSaved;

%hook YTMainAppControlsOverlayView

%property(retain, nonatomic) UIButton *optionsButton;

- (id)initWithDelegate:(id)delegate {
    self = %orig;
    if (self) {
        self.optionsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES) {
                [self.optionsButton addTarget:self action:@selector(iPhoneOptionsAction:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [self.optionsButton addTarget:self action:@selector(iPadOptionsAction:) forControlEvents:UIControlEventTouchUpInside];
            }
        } else {
            [self.optionsButton addTarget:self action:@selector(iPhoneOptionsAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.optionsButton setTitle:@"OP" forState:UIControlStateNormal];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES) {
            if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                self.optionsButton.frame = CGRectMake(40, 9, 28.0, 30.0);
            } else {
                self.optionsButton.frame = CGRectMake(40, 24, 28.0, 30.0);
            }
        } else {
            self.optionsButton.frame = CGRectMake(40, 9, 28.0, 30.0);
        }
        [self addSubview:self.optionsButton];
    }
    return self;
}

- (void)setTopOverlayVisible:(BOOL)visible isAutonavCanceledState:(BOOL)canceledState {
    if (canceledState) {
        if (!self.optionsButton.hidden)
            self.optionsButton.alpha = 0.0;
    } else {
        if (!self.optionsButton.hidden) {
            if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
                self.optionsButton.alpha = 0.0;
            } else {
                self.optionsButton.alpha = visible ? 1.0 : 0.0;
            }
        }
    }
    %orig;
}

%new;
- (void)iPadOptionsAction:(id)sender {
    NSLog(@"Popup Activated");

    NSString *videoIdentifier = [playingVideoID currentVideoID];
    NSString *videoTime = [NSString stringWithFormat: @"%f", [resultOut mediaTime]];
    float backToFloat = [videoTime floatValue];
    NSLog(@"VideoTime: %f", backToFloat);

    [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
	    if (video)
	    {
            AVPlayerViewController *playerViewController = [AVPlayerViewController new];
            __weak AVPlayerViewController *weakPlayerViewController = playerViewController;
            NSDictionary *streamURLs = video.streamURLs;
            NSURL *streamURL = streamURLs[@(XCDYouTubeVideoQualityHD720)] ?: streamURLs[@(XCDYouTubeVideoQualityMedium360)] ?: streamURLs[@(XCDYouTubeVideoQualitySmall240)] ?: streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming];
            NSLog(@"%@", streamURL);

            UIWindow *alertWindowMenu = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowMenu.rootViewController = [UIViewController new];
            alertWindowMenu.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutMenu = alertWindowMenu;

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Video Options" message:nil preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"Download Video (MP4 Video)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                alertWindowMenu.hidden = YES;

                UIWindow *alertWindowDownloading = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindowDownloading.rootViewController = [UIViewController new];
                alertWindowDownloading.windowLevel = UIWindowLevelAlert + 1;
                alertWindowOutDownloading = alertWindowDownloading;

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Video Is Downloading, Please Wait" preferredStyle:UIAlertControllerStyleAlert];

                [alertWindowDownloading makeKeyAndVisible];
                [alertWindowDownloading.rootViewController presentViewController:alert animated:YES completion:nil];

                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

                NSString *link = streamURL.absoluteString;
                NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", link]];
                NSString *startURL = @"https://www.googleapis.com/youtube/v3/videos?part=snippet&id=";
                NSString *endURL = @"&key=";
                NSString *apiURL = [NSString stringWithFormat: @"%@%@%@", startURL, videoIdentifier, endURL];
                NSURL *metadataURL = [NSURL URLWithString:apiURL];
                NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                NSURLRequest *metadataRequest = [NSURLRequest requestWithURL:metadataURL];

                NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:metadataRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                    if (error) {
                        NSLog(@"Error: %@", error);
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *videoTitle = [[responseObject valueForKeyPath:@"items.snippet"][0] objectForKey:@"title"];
                            NSString *artistTitle = [[responseObject valueForKeyPath:@"items.snippet"][0] objectForKey:@"channelTitle"];
                            NSLog(@"Video Title: %@", videoTitle);
                            NSLog(@"Artist Title: %@", artistTitle);
                            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                NSLog(@"File downloaded to: %@", filePath);
                                NSLog(@"Download Done");

                                NSFileManager * fm = [[NSFileManager alloc] init];
                                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                NSString *documentsDirectory = [paths objectAtIndex:0];
                                NSString *filePathSrc = [documentsDirectory stringByAppendingPathComponent:@"videoplayback.mp4"];
                                NSString *filePathAv = [documentsDirectory stringByAppendingPathComponent:@"videoplayback1.mp4"];
                                NSString *filePathDst = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", videoTitle]];
                                NSURL *outputRoll = [[NSURL alloc] initFileURLWithPath:filePathDst];
                                    
                                NSURL *inputURL = [[NSURL alloc] initFileURLWithPath:filePathSrc];
                                NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:filePathAv];

                                AVAsset *asset = [AVAsset assetWithURL:inputURL];
                                AVAssetExportSession * exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
                                exportSession.outputFileType = AVFileTypeMPEG4;
                                exportSession.outputURL = outputURL;

                                AVMutableMetadataItem *metaTitle = [[AVMutableMetadataItem alloc] init];
                                metaTitle.identifier = AVMetadataCommonIdentifierTitle;
                                metaTitle.dataType = (__bridge NSString *)kCMMetadataBaseDataType_UTF8;
                                metaTitle.value = videoTitle;

                                AVMutableMetadataItem *metaArtist = [[AVMutableMetadataItem alloc] init];
                                metaArtist.identifier = AVMetadataCommonIdentifierArtist;
                                metaArtist.dataType = (__bridge NSString *)kCMMetadataBaseDataType_UTF8;
                                metaArtist.value = artistTitle;

                                exportSession.metadata = @[metaTitle, metaArtist];

                                [exportSession exportAsynchronouslyWithCompletionHandler:^{
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (exportSession.status == AVAssetExportSessionStatusCompleted)
                                        {
                                            NSLog(@"AV Export Succeeded");
                                            [fm removeItemAtPath:filePathSrc error:nil];
                                            [fm removeItemAtPath:filePathDst error:nil];
                                            [fm moveItemAtPath:filePathAv toPath:filePathDst error:nil];
                                            NSLog(@"Name Changed");
                                            alertWindowDownloading.hidden = YES;

                                            UIWindow *alertWindowDownloaded = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                                            alertWindowDownloaded.rootViewController = [UIViewController new];
                                            alertWindowDownloaded.windowLevel = UIWindowLevelAlert + 1;
                                            alertWindowOutDownloaded = alertWindowDownloaded;

                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Video Download Complete \nFile Saved To YouTube's Document Directory" preferredStyle:UIAlertControllerStyleAlert];

                                            [alert addAction:[UIAlertAction actionWithTitle:@"Import Video To Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                alertWindowDownloaded.hidden = YES;
                                                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                                                    [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputRoll];
                                                } completionHandler:^(BOOL success, NSError *error) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if (success) {
                                                            NSLog(@"Video Saved");
                                                            UIWindow *alertWindowSaved = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                                                            alertWindowSaved.rootViewController = [UIViewController new];
                                                            alertWindowSaved.windowLevel = UIWindowLevelAlert + 1;
                                                            alertWindowOutSaved = alertWindowSaved;

                                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Video Saved To Camera Roll" preferredStyle:UIAlertControllerStyleAlert];
                                                                    
                                                            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                                alertWindowSaved.hidden = YES;
                                                            }]];

                                                            [alertWindowSaved makeKeyAndVisible];
                                                            [alertWindowSaved.rootViewController presentViewController:alert animated:YES completion:nil];
                                                        } else{
                                                            NSLog(@"%@", error.description);
                                                        }
                                                    });
                                                }];
                                            }]];
                            
                                            [alert addAction:[UIAlertAction actionWithTitle:@"Finish" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                alertWindowDownloaded.hidden = YES;
                                            }]];

                                            [alertWindowDownloaded makeKeyAndVisible];
                                            [alertWindowDownloaded.rootViewController presentViewController:alert animated:YES completion:nil];
                                            NSLog(@"Popup Appeared");
                                        }
                                        else if (exportSession.status == AVAssetExportSessionStatusCancelled)
                                        {
                                            NSLog(@"AV Export Cancelled");
                                        }
                                        else
                                        {
                                            NSLog(@"AV Export Failed With Error: %@ (%ld)", exportSession.error.localizedDescription, (long)exportSession.error.code);
                                        }
                                    });
                                }];
                            }];
                            [downloadTask resume];
                        });
                    }
                }];
                [dataTask resume];
            }]];

            [alert addAction:[UIAlertAction actionWithTitle:@"Play Video In Picture-In-Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                alertWindowMenu.hidden = YES;

                UIWindow *alertWindowPip = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindowPip.rootViewController = [UIViewController new];
                alertWindowPip.windowLevel = UIWindowLevelAlert + 1;
                alertWindowOutPip = alertWindowPip;

                weakPlayerViewController.player = [AVPlayer playerWithURL:streamURL];
                int32_t timeScale = weakPlayerViewController.player.currentItem.asset.duration.timescale;
                CMTime newTime = CMTimeMakeWithSeconds(backToFloat, timeScale);
                @try {
                    NSLog(@"Picture-In-Picture Allowed");
                    weakPlayerViewController.allowsPictureInPicturePlayback = YES;
                    if ([weakPlayerViewController respondsToSelector:@selector(setCanStartPictureInPictureAutomaticallyFromInline:)]) {
                        NSLog(@"Inline Compatible");
                        weakPlayerViewController.canStartPictureInPictureAutomaticallyFromInline = YES;
                    }
                    [weakPlayerViewController.player seekToTime:newTime completionHandler: ^(BOOL finished) {
                        [weakPlayerViewController.player play];
                    }];
                } 
                @catch(id anException) {
                    NSLog(@"Picture-In-Picture Allowed");
                    weakPlayerViewController.allowsPictureInPicturePlayback = YES;
                    if ([weakPlayerViewController respondsToSelector:@selector(setCanStartPictureInPictureAutomaticallyFromInline:)]) {
                        NSLog(@"Inline Compatible");
                        weakPlayerViewController.canStartPictureInPictureAutomaticallyFromInline = YES;
                    }
                    [weakPlayerViewController.player play];
                }

                [alertWindowPip makeKeyAndVisible];
                [alertWindowPip.rootViewController presentViewController:playerViewController animated:YES completion:nil];
            }]];

            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                alertWindowMenu.hidden = YES;
            }]];

            [alertWindowMenu makeKeyAndVisible];
            [alertWindowMenu.rootViewController presentViewController:alert animated:YES completion:nil];
        } else {
            NSLog(@"Error");
	    }
    }];
}

%new;
- (void)iPhoneOptionsAction:(id)sender {
    NSLog(@"Popup Activated");

    NSString *videoIdentifier = [playingVideoID currentVideoID];
    NSString *videoTime = [NSString stringWithFormat: @"%f", [resultOut mediaTime]];
    float backToFloat = [videoTime floatValue];
    NSLog(@"VideoTime: %f", backToFloat);

    [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
	    if (video)
	    {
            AVPlayerViewController *playerViewController = [AVPlayerViewController new];
            __weak AVPlayerViewController *weakPlayerViewController = playerViewController;
            NSDictionary *streamURLs = video.streamURLs;
            NSURL *streamURL = streamURLs[@(XCDYouTubeVideoQualityHD720)] ?: streamURLs[@(XCDYouTubeVideoQualityMedium360)] ?: streamURLs[@(XCDYouTubeVideoQualitySmall240)] ?: streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming];
            NSLog(@"%@", streamURL);

            UIWindow *alertWindowMenu = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowMenu.rootViewController = [UIViewController new];
            alertWindowMenu.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutMenu = alertWindowMenu;

            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Download Audio (M4A Audio)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                alertWindowMenu.hidden = YES;

                UIWindow *alertWindowDownloading = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindowDownloading.rootViewController = [UIViewController new];
                alertWindowDownloading.windowLevel = UIWindowLevelAlert + 1;
                alertWindowOutDownloading = alertWindowDownloading;

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Audio Is Downloading, Please Wait" preferredStyle:UIAlertControllerStyleAlert];

                [alertWindowDownloading makeKeyAndVisible];
                [alertWindowDownloading.rootViewController presentViewController:alert animated:YES completion:nil];

                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

                NSString *link = streamURL.absoluteString;
                NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", link]];
                NSString *startURL = @"https://www.googleapis.com/youtube/v3/videos?part=snippet&id=";
                NSString *endURL = @"&key=";
                NSString *apiURL = [NSString stringWithFormat: @"%@%@%@", startURL, videoIdentifier, endURL];
                NSURL *metadataURL = [NSURL URLWithString:apiURL];
                NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                NSURLRequest *metadataRequest = [NSURLRequest requestWithURL:metadataURL];

                NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:metadataRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                    if (error) {
                        NSLog(@"Error: %@", error);
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *videoTitle = [[responseObject valueForKeyPath:@"items.snippet"][0] objectForKey:@"title"];
                            NSString *artistTitle = [[responseObject valueForKeyPath:@"items.snippet"][0] objectForKey:@"channelTitle"];
                            NSLog(@"Video Title: %@", videoTitle);
                            NSLog(@"Artist Title: %@", artistTitle);
                            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                NSLog(@"File downloaded to: %@", filePath);
                                NSLog(@"Download Done");

                                NSFileManager * fm = [[NSFileManager alloc] init];
                                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                NSString *documentsDirectory = [paths objectAtIndex:0];
                                NSString *filePathSrc = [documentsDirectory stringByAppendingPathComponent:@"videoplayback.mp4"];
                                NSString *filePathAv = [documentsDirectory stringByAppendingPathComponent:@"videoplayback.m4a"];
                                NSString *filePathDst = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", videoTitle]];
                                    
                                NSURL *inputURL = [[NSURL alloc] initFileURLWithPath:filePathSrc];
                                NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:filePathAv];

                                AVAsset *asset = [AVAsset assetWithURL:inputURL];
                                AVAssetExportSession * exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
                                exportSession.outputFileType = AVFileTypeMPEG4;
                                exportSession.outputURL = outputURL;

                                AVMutableMetadataItem *metaTitle = [[AVMutableMetadataItem alloc] init];
                                metaTitle.identifier = AVMetadataCommonIdentifierTitle;
                                metaTitle.dataType = (__bridge NSString *)kCMMetadataBaseDataType_UTF8;
                                metaTitle.value = videoTitle;

                                AVMutableMetadataItem *metaArtist = [[AVMutableMetadataItem alloc] init];
                                metaArtist.identifier = AVMetadataCommonIdentifierArtist;
                                metaArtist.dataType = (__bridge NSString *)kCMMetadataBaseDataType_UTF8;
                                metaArtist.value = artistTitle;

                                exportSession.metadata = @[metaTitle, metaArtist];

                                [exportSession exportAsynchronouslyWithCompletionHandler:^{
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (exportSession.status == AVAssetExportSessionStatusCompleted)
                                        {
                                            NSLog(@"AV Export Succeeded");
                                            [fm removeItemAtPath:filePathSrc error:nil];
                                            [fm removeItemAtPath:filePathDst error:nil];
                                            [fm moveItemAtPath:filePathAv toPath:filePathDst error:nil];
                                            NSLog(@"Name Changed");
                                            alertWindowDownloading.hidden = YES;

                                            UIWindow *alertWindowDownloaded = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                                            alertWindowDownloaded.rootViewController = [UIViewController new];
                                            alertWindowDownloaded.windowLevel = UIWindowLevelAlert + 1;
                                            alertWindowOutDownloaded = alertWindowDownloaded;

                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Audio Download Complete \nFile Saved To YouTube's Document Directory" preferredStyle:UIAlertControllerStyleAlert];

                                            [alert addAction:[UIAlertAction actionWithTitle:@"Finish" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                alertWindowDownloaded.hidden = YES;
                                            }]];

                                            [alertWindowDownloaded makeKeyAndVisible];
                                            [alertWindowDownloaded.rootViewController presentViewController:alert animated:YES completion:nil];
                                            NSLog(@"Popup Appeared");
                                        }
                                        else if (exportSession.status == AVAssetExportSessionStatusCancelled)
                                        {
                                            NSLog(@"AV Export Cancelled");
                                        }
                                        else
                                        {
                                            NSLog(@"AV Export Failed With Error: %@ (%ld)", exportSession.error.localizedDescription, (long)exportSession.error.code);
                                        }
                                    });
                                }];
                            }];
                            [downloadTask resume];
                        });
                    }
                }];
                [dataTask resume];
            }]];

            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Download Video (MP4 Video)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                alertWindowMenu.hidden = YES;

                UIWindow *alertWindowDownloading = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindowDownloading.rootViewController = [UIViewController new];
                alertWindowDownloading.windowLevel = UIWindowLevelAlert + 1;
                alertWindowOutDownloading = alertWindowDownloading;

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Video Is Downloading, Please Wait" preferredStyle:UIAlertControllerStyleAlert];

                [alertWindowDownloading makeKeyAndVisible];
                [alertWindowDownloading.rootViewController presentViewController:alert animated:YES completion:nil];

                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

                NSString *link = streamURL.absoluteString;
                NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", link]];
                NSString *startURL = @"https://www.googleapis.com/youtube/v3/videos?part=snippet&id=";
                NSString *endURL = @"&key=";
                NSString *apiURL = [NSString stringWithFormat: @"%@%@%@", startURL, videoIdentifier, endURL];
                NSURL *metadataURL = [NSURL URLWithString:apiURL];
                NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                NSURLRequest *metadataRequest = [NSURLRequest requestWithURL:metadataURL];

                NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:metadataRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                    if (error) {
                        NSLog(@"Error: %@", error);
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *videoTitle = [[responseObject valueForKeyPath:@"items.snippet"][0] objectForKey:@"title"];
                            NSString *artistTitle = [[responseObject valueForKeyPath:@"items.snippet"][0] objectForKey:@"channelTitle"];
                            NSLog(@"Video Title: %@", videoTitle);
                            NSLog(@"Artist Title: %@", artistTitle);
                            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                NSLog(@"File downloaded to: %@", filePath);
                                NSLog(@"Download Done");

                                NSFileManager * fm = [[NSFileManager alloc] init];
                                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                NSString *documentsDirectory = [paths objectAtIndex:0];
                                NSString *filePathSrc = [documentsDirectory stringByAppendingPathComponent:@"videoplayback.mp4"];
                                NSString *filePathAv = [documentsDirectory stringByAppendingPathComponent:@"videoplayback1.mp4"];
                                NSString *filePathDst = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", videoTitle]];
                                NSURL *outputRoll = [[NSURL alloc] initFileURLWithPath:filePathDst];
                                    
                                NSURL *inputURL = [[NSURL alloc] initFileURLWithPath:filePathSrc];
                                NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:filePathAv];

                                AVAsset *asset = [AVAsset assetWithURL:inputURL];
                                AVAssetExportSession * exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
                                exportSession.outputFileType = AVFileTypeMPEG4;
                                exportSession.outputURL = outputURL;

                                AVMutableMetadataItem *metaTitle = [[AVMutableMetadataItem alloc] init];
                                metaTitle.identifier = AVMetadataCommonIdentifierTitle;
                                metaTitle.dataType = (__bridge NSString *)kCMMetadataBaseDataType_UTF8;
                                metaTitle.value = videoTitle;

                                AVMutableMetadataItem *metaArtist = [[AVMutableMetadataItem alloc] init];
                                metaArtist.identifier = AVMetadataCommonIdentifierArtist;
                                metaArtist.dataType = (__bridge NSString *)kCMMetadataBaseDataType_UTF8;
                                metaArtist.value = artistTitle;

                                exportSession.metadata = @[metaTitle, metaArtist];

                                [exportSession exportAsynchronouslyWithCompletionHandler:^{
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (exportSession.status == AVAssetExportSessionStatusCompleted)
                                        {
                                            NSLog(@"AV Export Succeeded");
                                            [fm removeItemAtPath:filePathSrc error:nil];
                                            [fm removeItemAtPath:filePathDst error:nil];
                                            [fm moveItemAtPath:filePathAv toPath:filePathDst error:nil];
                                            NSLog(@"Name Changed");
                                            alertWindowDownloading.hidden = YES;

                                            UIWindow *alertWindowDownloaded = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                                            alertWindowDownloaded.rootViewController = [UIViewController new];
                                            alertWindowDownloaded.windowLevel = UIWindowLevelAlert + 1;
                                            alertWindowOutDownloaded = alertWindowDownloaded;

                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Video Download Complete \nFile Saved To YouTube's Document Directory" preferredStyle:UIAlertControllerStyleAlert];

                                            [alert addAction:[UIAlertAction actionWithTitle:@"Import Video To Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                alertWindowDownloaded.hidden = YES;
                                                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                                                    [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputRoll];
                                                } completionHandler:^(BOOL success, NSError *error) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if (success) {
                                                            NSLog(@"Video Saved");
                                                            UIWindow *alertWindowSaved = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                                                            alertWindowSaved.rootViewController = [UIViewController new];
                                                            alertWindowSaved.windowLevel = UIWindowLevelAlert + 1;
                                                            alertWindowOutSaved = alertWindowSaved;

                                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Video Saved To Camera Roll" preferredStyle:UIAlertControllerStyleAlert];
                                                                    
                                                            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                                alertWindowSaved.hidden = YES;
                                                            }]];

                                                            [alertWindowSaved makeKeyAndVisible];
                                                            [alertWindowSaved.rootViewController presentViewController:alert animated:YES completion:nil];
                                                        } else{
                                                            NSLog(@"%@", error.description);
                                                        }
                                                    });
                                                }];
                                            }]];
                            
                                            [alert addAction:[UIAlertAction actionWithTitle:@"Finish" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                alertWindowDownloaded.hidden = YES;
                                            }]];

                                            [alertWindowDownloaded makeKeyAndVisible];
                                            [alertWindowDownloaded.rootViewController presentViewController:alert animated:YES completion:nil];
                                            NSLog(@"Popup Appeared");
                                        }
                                        else if (exportSession.status == AVAssetExportSessionStatusCancelled)
                                        {
                                            NSLog(@"AV Export Cancelled");
                                        }
                                        else
                                        {
                                            NSLog(@"AV Export Failed With Error: %@ (%ld)", exportSession.error.localizedDescription, (long)exportSession.error.code);
                                        }
                                    });
                                }];
                            }];
                            [downloadTask resume];
                        });
                    }
                }];
                [dataTask resume];
            }]];

            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Play Video In Picture-In-Picture (iOS 14+)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                alertWindowMenu.hidden = YES;

                UIWindow *alertWindowPip = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindowPip.rootViewController = [UIViewController new];
                alertWindowPip.windowLevel = UIWindowLevelAlert + 1;
                alertWindowOutPip = alertWindowPip;

                weakPlayerViewController.player = [AVPlayer playerWithURL:streamURL];
                int32_t timeScale = weakPlayerViewController.player.currentItem.asset.duration.timescale;
                CMTime newTime = CMTimeMakeWithSeconds(backToFloat, timeScale);
                @try {
                    NSLog(@"Picture-In-Picture Allowed");
                    weakPlayerViewController.allowsPictureInPicturePlayback = YES;
                    if ([weakPlayerViewController respondsToSelector:@selector(setCanStartPictureInPictureAutomaticallyFromInline:)]) {
                        NSLog(@"Inline Compatible");
                        weakPlayerViewController.canStartPictureInPictureAutomaticallyFromInline = YES;
                    }
                    [weakPlayerViewController.player seekToTime:newTime completionHandler: ^(BOOL finished) {
                        [weakPlayerViewController.player play];
                    }];
                } 
                @catch(id anException) {
                    NSLog(@"Picture-In-Picture Allowed");
                    weakPlayerViewController.allowsPictureInPicturePlayback = YES;
                    if ([weakPlayerViewController respondsToSelector:@selector(setCanStartPictureInPictureAutomaticallyFromInline:)]) {
                        NSLog(@"Inline Compatible");
                        weakPlayerViewController.canStartPictureInPictureAutomaticallyFromInline = YES;
                    }
                    [weakPlayerViewController.player play];
                }

                [alertWindowPip makeKeyAndVisible];
                [alertWindowPip.rootViewController presentViewController:playerViewController animated:YES completion:nil];
            }]];

            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                alertWindowMenu.hidden = YES;
            }]];

            [alertWindowMenu makeKeyAndVisible];
            [alertWindowMenu.rootViewController presentViewController:actionSheet animated:YES completion:nil];
        } else {
            NSLog(@"Error");
	    }
    }];
}
%end

%hook AVPlayerViewController
- (void)viewWillDisappear:(BOOL)animated {
    alertWindowOutPip.hidden = YES;
    %orig;
}
%end

%hook YTSettings
- (BOOL)allowAudioOnlyManualQualitySelection {
    return 1;
}
%end

%hook YTUpsell
- (BOOL)isCounterfactual {
    return 1;
}
%end

%ctor {
    @autoreleasepool {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableBackgroundPlayback"] == YES) %init(gBackgroundPlayback);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoDownloadButton"] == YES) %init(gNoDownloadButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoCommentsSection"] == YES) %init(gNoCommentsSection);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoCastButton"] == YES) %init(gNoCastButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoNotificationButton"] == YES) %init(gNoNotificationButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAllowHDOnCellularData"] == YES) %init(gAllowHDOnCellularData);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoEndscreenPopups"] == YES) %init(gDisableVideoEndscreenPopups);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableYouTubeKidsPopup"] == YES) %init(gDisableYouTubeKidsPopup);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableAgeRestriction"] == YES) %init(gDisableAgeRestriction);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVoiceSearch"] == YES) %init(gDisableVoiceSearch);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableHints"] == YES) %init(gDisableHints);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBarLabels"] == YES) %init(gHideTabBarLabels);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideExploreTab"] == YES) %init(gHideExploreTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideUploadTab"] == YES) %init(gHideUploadTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideSubscriptionsTab"] == YES) %init(gHideSubscriptionsTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideLibraryTab"] == YES) %init(gHideLibraryTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableDoubleTapToSkip"] == YES) %init(gDisableDoubleTapToSkip);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoTopicsSection"] == YES) %init(gNoTopicsSection);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideOverlayDarkBackground"] == YES) %init(gHideOverlayDarkBackground);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHidePreviousAndNextButtonInOverlay"] == YES) %init(gHidePreviousAndNextButtonInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoAutoPlay"] == YES) %init(gDisableVideoAutoPlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableOledDarkModeOne"] == YES) %init(gEnableOledDarkMode);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideAutoPlaySwitchInOverlay"] == YES) %init(gHideAutoPlaySwitchInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideCaptionsSubtitlesButtonInOverlay"] == YES) %init(gHideCaptionsSubtitlesButtonInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoInfoCards"] == YES) %init(gDisableVideoInfoCards);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoSearchButton"] == YES) %init(gNoSearchButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == NO & [[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES) {
            %init(gShowStatusBarInOverlay);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES or [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == NO) {
            %init(gEnableiPadStyleOniPhone);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAlwaysShowPlayerBar"] == NO & [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"] == YES) {
            %init(gDisableRelatedVideosInOverlay);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAlwaysShowPlayerBar"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"] == YES or [[NSUserDefaults standardUserDefaults] boolForKey:@"kAlwaysShowPlayerBar"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"] == NO) {
            %init(gAlwaysShowPlayerBar);
        }
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
        [unarchiver setRequiresSecureCoding:NO];
        UIColor *selectedColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
        if(selectedColour != nil) {
            %init(gColourOptions);
        }
		%init(_ungrouped);
    }
}