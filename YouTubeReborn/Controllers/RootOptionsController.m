#import "RootOptionsController.h"
#import "VideoOptionsController.h"
#import "OverlayOptionsController.h"
#import "TabBarOptionsController.h"
#import "ColourOptionsController.h"
#import "CreditsOptionsController.h"

@implementation RootOptionsController

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

UIWindow *alertWindowOutVideo;
UIWindow *alertWindowOutOverlay;
UIWindow *alertWindowOutTabBar;
UIWindow *alertWindowOutColour;
UIWindow *alertWindowOutCredits;

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.title = @"YouTube Reborn Options";
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.view.backgroundColor = [UIColor blackColor];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = doneButton;

    UIBarButtonItem* applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(apply)];
    self.navigationItem.rightBarButtonItem = applyButton;

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14.0")) {
            return 4;
        } else {
            return 3;
        }
    }
    if (section == 1) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14.0")) {
            return 10;
        } else {
            return 11;
        }
    }
    if (section == 2) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RootTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if(@available(iOS 13.0, *)) {
            if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.textColor = [UIColor blackColor];
            }
            else {
                cell.backgroundColor = [UIColor blackColor];
                cell.textLabel.textColor = [UIColor whiteColor];
            }
        }
        else {
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Video Options";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 1) {
                cell.textLabel.text = @"Overlay Options";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 2) {
                cell.textLabel.text = @"Tab Bar Options";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 3) {
                cell.textLabel.text = @"Colour Options";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        if(indexPath.section == 1) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Enable iPad Style On iPhone";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *enableiPadStyleOniPhone = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [enableiPadStyleOniPhone addTarget:self action:@selector(toggleEnableiPadStyleOniPhone:) forControlEvents:UIControlEventValueChanged];
                enableiPadStyleOniPhone.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"];
                cell.accessoryView = enableiPadStyleOniPhone;
            }
            if(indexPath.row == 1) {
                cell.textLabel.text = @"No Download Button";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noDownloadButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [noDownloadButton addTarget:self action:@selector(toggleNoDownloadButton:) forControlEvents:UIControlEventValueChanged];
                noDownloadButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoDownloadButton"];
                cell.accessoryView = noDownloadButton;
            }
            if(indexPath.row == 2) {
                cell.textLabel.text = @"No Comments Section";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noCommentsSection = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [noCommentsSection addTarget:self action:@selector(toggleNoCommentsSection:) forControlEvents:UIControlEventValueChanged];
                noCommentsSection.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoCommentsSection"];
                cell.accessoryView = noCommentsSection;
            }
            if(indexPath.row == 3) {
                cell.textLabel.text = @"No Cast Button";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noCastButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [noCastButton addTarget:self action:@selector(toggleNoCastButton:) forControlEvents:UIControlEventValueChanged];
                noCastButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoCastButton"];
                cell.accessoryView = noCastButton;
            }
            if(indexPath.row == 4) {
                cell.textLabel.text = @"No Notification Button";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noNotificationButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [noNotificationButton addTarget:self action:@selector(toggleNoNotificationButton:) forControlEvents:UIControlEventValueChanged];
                noNotificationButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoNotificationButton"];
                cell.accessoryView = noNotificationButton;
            }
            if(indexPath.row == 5) {
                cell.textLabel.text = @"No Search Button";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noSearchButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [noSearchButton addTarget:self action:@selector(toggleNoSearchButton:) forControlEvents:UIControlEventValueChanged];
                noSearchButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoSearchButton"];
                cell.accessoryView = noSearchButton;
            }
            if(indexPath.row == 6) {
                cell.textLabel.text = @"No Topics Section";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noTopicsSection = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [noTopicsSection addTarget:self action:@selector(toggleNoTopicsSection:) forControlEvents:UIControlEventValueChanged];
                noTopicsSection.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoTopicsSection"];
                cell.accessoryView = noTopicsSection;
            }
            if(indexPath.row == 7) {
                cell.textLabel.text = @"Disable YouTube Kids Popup";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *disableYouTubeKidsPopup = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [disableYouTubeKidsPopup addTarget:self action:@selector(toggleDisableYouTubeKidsPopup:) forControlEvents:UIControlEventValueChanged];
                disableYouTubeKidsPopup.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableYouTubeKidsPopup"];
                cell.accessoryView = disableYouTubeKidsPopup;
            }
            if(indexPath.row == 8) {
                cell.textLabel.text = @"Disable Voice Search";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *disableVoiceSearch = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [disableVoiceSearch addTarget:self action:@selector(toggleDisableVoiceSearch:) forControlEvents:UIControlEventValueChanged];
                disableVoiceSearch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVoiceSearch"];
                cell.accessoryView = disableVoiceSearch;
            }
            if(indexPath.row == 9) {
                cell.textLabel.text = @"Disable Hints";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *disableHints = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [disableHints addTarget:self action:@selector(toggleDisableHints:) forControlEvents:UIControlEventValueChanged];
                disableHints.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableHints"];
                cell.accessoryView = disableHints;
            }
            if(indexPath.row == 10) {
                cell.textLabel.text = @"Enable Oled Dark Mode";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *enableOledDarkMode = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [enableOledDarkMode addTarget:self action:@selector(toggleEnableOledDarkMode:) forControlEvents:UIControlEventValueChanged];
                enableOledDarkMode.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableOledDarkModeOne"];
                cell.accessoryView = enableOledDarkMode;
            }
        }
        if(indexPath.section == 2) {
            if(indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if(indexPath.row == 1) {
                cell.textLabel.text = @"Credits";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 2) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            UIWindow *alertWindowVideo = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowVideo.rootViewController = [UIViewController new];
            alertWindowVideo.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutVideo = alertWindowVideo;
    
            VideoOptionsController* videoOptionsController = [[VideoOptionsController alloc] init];
            UINavigationController* videoOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:videoOptionsController];
            videoOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [alertWindowVideo makeKeyAndVisible];
            [alertWindowVideo.rootViewController presentViewController:videoOptionsControllerView animated:YES completion:nil];
        }
        if(indexPath.row == 1) {
            UIWindow *alertWindowOverlay = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowOverlay.rootViewController = [UIViewController new];
            alertWindowOverlay.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutOverlay = alertWindowOverlay;
    
            OverlayOptionsController* overlayOptionsController = [[OverlayOptionsController alloc] init];
            UINavigationController* overlayOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:overlayOptionsController];
            overlayOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [alertWindowOverlay makeKeyAndVisible];
            [alertWindowOverlay.rootViewController presentViewController:overlayOptionsControllerView animated:YES completion:nil];
        }
        if(indexPath.row == 2) {
            UIWindow *alertWindowTabBar = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowTabBar.rootViewController = [UIViewController new];
            alertWindowTabBar.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutTabBar = alertWindowTabBar;
    
            TabBarOptionsController* tabBarOptionsController = [[TabBarOptionsController alloc] init];
            UINavigationController* tabBarOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:tabBarOptionsController];
            tabBarOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [alertWindowTabBar makeKeyAndVisible];
            [alertWindowTabBar.rootViewController presentViewController:tabBarOptionsControllerView animated:YES completion:nil];
        }
        if(indexPath.row == 3) {
            UIWindow *alertWindowColour = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowColour.rootViewController = [UIViewController new];
            alertWindowColour.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutColour = alertWindowColour;
    
            ColourOptionsController* colourOptionsController = [[ColourOptionsController alloc] init];
            UINavigationController* colourOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:colourOptionsController];
            colourOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [alertWindowColour makeKeyAndVisible];
            [alertWindowColour.rootViewController presentViewController:colourOptionsControllerView animated:YES completion:nil];
        }
    }
    if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            UIWindow *alertWindowCredits = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowCredits.rootViewController = [UIViewController new];
            alertWindowCredits.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutCredits = alertWindowCredits;
    
            CreditsOptionsController* creditsOptionsController = [[CreditsOptionsController alloc] init];
            UINavigationController* creditsOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:creditsOptionsController];
            creditsOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [alertWindowCredits makeKeyAndVisible];
            [alertWindowCredits.rootViewController presentViewController:creditsOptionsControllerView animated:YES completion:nil];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return @"Version: 2.0.0.3";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if(@available(iOS 13.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            view.tintColor = [UIColor whiteColor];
        }
        else {
            view.tintColor = [UIColor blackColor];
        }
    }
    else {
        view.tintColor = [UIColor whiteColor];
    }
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tableSection"]]];
    [footer.textLabel setFont:[UIFont systemFontOfSize:14]];
    footer.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
}

@end

@implementation RootOptionsController(Privates)

- (void)done
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Closed RootOptionsController");
    }];
}

- (void)apply
{
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
    [NSThread sleepForTimeInterval:2.0];
    exit(0); 
}

- (void)toggleEnableiPadStyleOniPhone:(UISwitch*)sender
{
    UISwitch *enableiPadStyleOniPhoneSwitch = (UISwitch *)sender;
    if ([enableiPadStyleOniPhoneSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kEnableiPadStyleOniPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kEnableiPadStyleOniPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleEnableOledDarkMode:(UISwitch*)sender
{
    UISwitch *enableOledDarkModeSwitch = (UISwitch *)sender;
    if ([enableOledDarkModeSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kEnableOledDarkModeOne"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kEnableOledDarkModeOne"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoDownloadButton:(UISwitch*)sender
{
    UISwitch *noDownloadButtonSwitch = (UISwitch *)sender;
    if ([noDownloadButtonSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoDownloadButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoDownloadButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoCommentsSection:(UISwitch*)sender
{
    UISwitch *noCommentsSectionSwitch = (UISwitch *)sender;
    if ([noCommentsSectionSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoCommentsSection"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoCommentsSection"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoCastButton:(UISwitch*)sender
{
    UISwitch *noCastButtonSwitch = (UISwitch *)sender;
    if ([noCastButtonSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoCastButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoCastButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoNotificationButton:(UISwitch*)sender
{
    UISwitch *noNotificationButtonSwitch = (UISwitch *)sender;
    if ([noNotificationButtonSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoNotificationButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoNotificationButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoSearchButton:(UISwitch*)sender
{
    UISwitch *noSearchButtonSwitch = (UISwitch *)sender;
    if ([noSearchButtonSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoSearchButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoSearchButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoTopicsSection:(UISwitch*)sender
{
    UISwitch *noTopicsSectionSwitch = (UISwitch *)sender;
    if ([noTopicsSectionSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoTopicsSection"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoTopicsSection"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableYouTubeKidsPopup:(UISwitch*)sender
{
    UISwitch *disableYouTubeKidsPopupSwitch = (UISwitch *)sender;
    if ([disableYouTubeKidsPopupSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableYouTubeKidsPopup"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableYouTubeKidsPopup"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableVoiceSearch:(UISwitch*)sender
{
    UISwitch *disableVoiceSearchSwitch = (UISwitch *)sender;
    if ([disableVoiceSearchSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableVoiceSearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableVoiceSearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableHints:(UISwitch*)sender
{
    UISwitch *disableHintsSwitch = (UISwitch *)sender;
    if ([disableHintsSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableHints"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableHints"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end