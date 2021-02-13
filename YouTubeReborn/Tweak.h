@interface YTQTMButton: UIButton
@end

@interface ABCSwitch: UISwitch
@end

@interface YTPivotBarItemView: UIView
@property(readonly, nonatomic) YTQTMButton *navigationButton;
@end

@interface YTPivotBarView: UIView
@end

@interface YTSlideForActionsView: UIView
@end

@interface YTEngagementPanelView: UIView
@end

@interface YTShareMainView: UIView
@end

@interface ELMView: UIView
@end

@interface YTTopAlignedView: UIView
@end

@interface YTRightNavigationButtons
@property(readonly, nonatomic) YTQTMButton *MDXButton;
@property(readonly, nonatomic) YTQTMButton *searchButton;
@property(readonly, nonatomic) YTQTMButton *notificationButton;
@end

@interface YTMainAppControlsOverlayView : UIView
@property(readonly, nonatomic) YTQTMButton *playbackRouteButton;
@property(readonly, nonatomic) YTQTMButton *previousButton;
@property(readonly, nonatomic) YTQTMButton *nextButton;
@property(readonly, nonatomic) ABCSwitch *autonavSwitch;
@property(readonly, nonatomic) YTQTMButton *closedCaptionsOrSubtitlesButton;
@property(retain, nonatomic) UIButton *optionsButton;
- (void)iPadOptionsAction:(id)sender;
- (void)iPhoneOptionsAction:(id)sender;
@end

@interface YTMainAppSkipVideoButton
@property(readonly, nonatomic) UIImageView *imageView;
@end

@interface YTPlayerViewController
- (NSString *)currentVideoID;
@end

@interface YTLocalPlaybackController
- (NSString *)currentVideoID;
@end

@interface YTMainAppVideoPlayerOverlayViewController
- (CGFloat)mediaTime;
@end

@interface YTCollectionView : UIView
@end

@interface YTAsyncCollectionView : UIView
@end

@interface YTNavigationBarTitleView : UIView
- (void)rootOptionsAction:(id)sender;
@end