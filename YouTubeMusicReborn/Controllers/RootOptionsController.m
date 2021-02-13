#import "RootOptionsController.h"
#import "VideoOptionsController.h"
#import "OverlayOptionsController.h"
#import "TabBarOptionsController.h"
#import "CreditsOptionsController.h"

@implementation RootOptionsController

UIWindow *alertWindowOutVideo;
UIWindow *alertWindowOutOverlay;
UIWindow *alertWindowOutTabBar;
UIWindow *alertWindowOutCredits;

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.title = @"YouTube Music Reborn Options";
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
        return 3;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 2;
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
        }
        if(indexPath.section == 1) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Disable Voice Search";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *disableVoiceSearch = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [disableVoiceSearch addTarget:self action:@selector(toggleDisableVoiceSearch:) forControlEvents:UIControlEventValueChanged];
                disableVoiceSearch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVoiceSearch"];
                cell.accessoryView = disableVoiceSearch;
            }
            if(indexPath.row == 1) {
                cell.textLabel.text = @"Disable Hints";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *disableHints = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [disableHints addTarget:self action:@selector(toggleDisableHints:) forControlEvents:UIControlEventValueChanged];
                disableHints.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableHints"];
                cell.accessoryView = disableHints;
            }
            if(indexPath.row == 2) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        if(indexPath.section == 2) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Credits";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 1) {
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
        return @"Version: 2.0.0.2";
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