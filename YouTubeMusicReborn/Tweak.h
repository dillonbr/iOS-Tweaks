@interface YTQTMButton: UIButton
@end

@interface ABCSwitch: UISwitch
@end

@interface YTPivotBarItemView: UIView
@property(readonly, nonatomic) YTQTMButton *navigationButton;
@end

@interface YTPivotBarView: UIView
@end

@interface YTPlayerViewController
- (NSString *)currentVideoID;
@end

@interface YTLocalPlaybackController
- (NSString *)currentVideoID;
@end

@interface YTCollectionView : UIView
@end

@interface YTAsyncCollectionView : UIView
@end

@interface YTMSearchQueryView : UIView
@end

@interface YTMNavigationBarView : UIView
- (void)rootOptionsAction:(id)sender;
@end