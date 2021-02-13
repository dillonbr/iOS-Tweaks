#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Controllers/RootOptionsController.h"
#import "Tweak.h"

%hook YTMAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *actualVersion = [info objectForKey:@"CFBundleShortVersionString"];
    NSString* requiredVersion = @"4.05";
    if ([requiredVersion compare:actualVersion options:NSNumericSearch] == NSOrderedDescending) {
        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [UIViewController new];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:[NSString stringWithFormat:@"Your YouTube Music version (%@) is to low to support YouTube Music Reborn, please update YouTube Music to version 4.05+ in order to use YouTube Music Reborn", actualVersion] preferredStyle:UIAlertControllerStyleAlert];

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
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ytMusicRebornFirstTimeAlertViewShownOnce"] == NO) {
            UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindow.rootViewController = [UIViewController new];
            alertWindow.windowLevel = UIWindowLevelAlert + 1;

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"YouTube Music Reborn" message:@"\nWelcome To YouTube Music Reborn v2 \n\nYou can access the new preferences by pressing on the 'OP' button in the top left corner of yt music, next to the logo" preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"Thank You" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                alertWindow.hidden = YES;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ytMusicRebornFirstTimeAlertViewShownOnce"];
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
%hook YTMSearchQueryView
- (void)layoutSubviews {
	%orig();
    MSHookIvar<YTMSearchQueryView *>(self, "_voiceButton").hidden = YES;
}
%end
%end

%group gDisableHints
%hook YTMSettings
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

%group gHideLibraryTab
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

%group gHideUpgradeTab
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

%group gHideTabBarLabels
%hook YTPivotBarItemView
- (void)layoutSubviews {
    %orig();
    [[self navigationButton] setTitle:@"" forState:UIControlStateNormal];
    [[self navigationButton] setTitle:@"" forState:UIControlStateSelected];
}
%end
%end

%group gEnableDoubleTapToSkip
%hook YTDoubleTapToSeekController
- (void)enableDoubleTapToSeek:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
- (void)showDoubleTapToSeekEducationView:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTMSettings
- (BOOL)doubleTapToSeekEnabled {
    return 1;
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
%hook YTMSettings
- (BOOL)disableHDOnCellular {
	return 0;
}
- (void)setDisableHDOnCellular:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%end

%group gDisableOverlayAutoHide
%hook YTMVideoOverlayViewController
- (void)maybeAutoHideOverlay {
}
%end
%end

%group gShowStatusBarInOverlay
%hook YTMSettings
- (BOOL)showStatusBarWithOverlay {
    return 1;
}
%end
%end

UIWindow *alertWindowOutOptions;
UIWindow *alertWindowOutVideo;
UIWindow *alertWindowOutOverlay;
UIWindow *alertWindowOutTabBar;
UIWindow *alertWindowOutCredits;

%hook YTMNavigationBarView
- (void)layoutSubviews {
	%orig();
    UIView *optionsView = MSHookIvar<YTMNavigationBarView *>(self, "_logoNavImage");
    [self bringSubviewToFront:optionsView];
    UIImageView *imageView = (UIImageView *)optionsView;
    imageView.contentMode = UIViewContentModeTopLeft;
    CGRect extend = imageView.frame;
    extend.size.width += 45;
    imageView.frame = extend;
    [optionsView setUserInteractionEnabled:YES];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(rootOptionsAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"OP" forState:UIControlStateNormal];
    button.frame = CGRectMake(90, 0, 24.0, 24.0);
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

%hook CreditsOptionsController
- (void)viewWillDisappear:(BOOL)animated {
    alertWindowOutCredits.hidden = YES;
    %orig;
}
%end

%hook YTMAudioCastUpsellDialogController
- (id)showAudioCastUpsellDialogWithUpsellParentResponder:(id)arg1 {
    return NULL;
}
%end

%hook YTMUpsellDialogController
- (id)showUpsellDialogWithUpsell:(id)arg1 upsellParentResponder:(id)arg2 {
    return NULL;
}
- (id)showUpsellDialogWithUpsellResponderEvent:(id)arg1 {
    return NULL;
}
- (id)showUpsellDialogWithUpsell:(id)arg1 videoID:(id)arg2 toastType:(int)arg3 upsellParentResponder:(id)arg4 {
    return NULL;
}
%end

%hook YTMBackgroundUpsellNotificationController
- (id)removePendingBackgroundNotifications {
    return NULL;
}
- (id)maybeScheduleBackgroundUpsellNotification {
    return NULL;
}
%end

%hook YTMNavigationDrawerPromoView
- (id)init {
    return NULL;
}
%end

%hook YTIPlayerResponse
- (BOOL)ytm_isAudioOnlyPlayable {
    return 1;
}
- (id)ytm_audioOnlyUpsell {
    return NULL;
}
%end

%hook YTMVideoOverlayViewController
- (id)maybeShowAudioOnlyUpsell {
    return NULL;
}
- (BOOL)isAVSwitchAvailable {
    return 1;
}
- (BOOL)showAVSwitchUserEducation {
    return 0;
}
- (BOOL)isAudioOnlyAuthorized {
    return 1;
}
- (void)setAVSwitchAvailable:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end

%hook YTMSettings
- (BOOL)allowAudioOnlyManualQualitySelection {
    return 1;
}
%end

%hook YTMWatchViewController
- (BOOL)isAudioOnlyAuthorized:(id)arg1 {
    return 1;
}
%end

%hook YTMMusicAppMetadata
- (BOOL)isAudioOnlyButtonVisible {
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
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableAgeRestriction"] == YES) %init(gDisableAgeRestriction);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableDoubleTapToSkip"] == YES) %init(gEnableDoubleTapToSkip);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAllowHDOnCellularData"] == YES) %init(gAllowHDOnCellularData);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableOverlayAutoHide"] == YES) %init(gDisableOverlayAutoHide);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES) %init(gShowStatusBarInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVoiceSearch"] == YES) %init(gDisableVoiceSearch);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableHints"] == YES) %init(gDisableHints);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBarLabels"] == YES) %init(gHideTabBarLabels);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideExploreTab"] == YES) %init(gHideExploreTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideLibraryTab"] == YES) %init(gHideLibraryTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideUpgradeTab"] == YES) %init(gHideUpgradeTab);
		%init(_ungrouped);
    }
}