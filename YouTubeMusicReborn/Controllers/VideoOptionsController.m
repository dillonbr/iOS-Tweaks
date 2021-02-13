#import "VideoOptionsController.h"

@implementation VideoOptionsController

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.title = @"YouTube Music Reborn Video Options";
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.view.backgroundColor = [UIColor blackColor];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VideoTableViewCell";
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
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Enable Background Playback";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *enableBackgroundPlayback = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [enableBackgroundPlayback addTarget:self action:@selector(toggleEnableBackgroundPlayback:) forControlEvents:UIControlEventValueChanged];
            enableBackgroundPlayback.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableBackgroundPlayback"];
            cell.accessoryView = enableBackgroundPlayback;
        }
        if(indexPath.row == 1) {
            cell.textLabel.text = @"Allow HD On Cellular Data";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *allowHDOnCellularData = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [allowHDOnCellularData addTarget:self action:@selector(toggleAllowHDOnCellularData:) forControlEvents:UIControlEventValueChanged];
            allowHDOnCellularData.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kAllowHDOnCellularData"];
            cell.accessoryView = allowHDOnCellularData;
        }
        if(indexPath.row == 2) {
            cell.textLabel.text = @"Enable Double Tap To Skip";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *enableDoubleTapToSkip = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [enableDoubleTapToSkip addTarget:self action:@selector(toggleEnableDoubleTapToSkip:) forControlEvents:UIControlEventValueChanged];
            enableDoubleTapToSkip.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableDoubleTapToSkip"];
            cell.accessoryView = enableDoubleTapToSkip;
        }
        if(indexPath.row == 3) {
            cell.textLabel.text = @"Disable Age Restriction";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *disableAgeRestriction = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [disableAgeRestriction addTarget:self action:@selector(toggleDisableAgeRestriction:) forControlEvents:UIControlEventValueChanged];
            disableAgeRestriction.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableAgeRestriction"];
            cell.accessoryView = disableAgeRestriction;
        }
    }
    return cell;
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

@implementation VideoOptionsController(Privates)

- (void)done
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Closed VideoOptionsController");
    }];
}

- (void)toggleEnableBackgroundPlayback:(UISwitch*)sender
{
    UISwitch *enableBackgroundPlaybackSwitch = (UISwitch *)sender;
    if ([enableBackgroundPlaybackSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kEnableBackgroundPlayback"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kEnableBackgroundPlayback"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleAllowHDOnCellularData:(UISwitch*)sender
{
    UISwitch *allowHDOnCellularDataSwitch = (UISwitch *)sender;
    if ([allowHDOnCellularDataSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kAllowHDOnCellularData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kAllowHDOnCellularData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleEnableDoubleTapToSkip:(UISwitch*)sender
{
    UISwitch *enableDoubleTapToSkipSwitch = (UISwitch *)sender;
    if ([enableDoubleTapToSkipSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kEnableDoubleTapToSkip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kEnableDoubleTapToSkip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableAgeRestriction:(UISwitch*)sender
{
    UISwitch *disableAgeRestrictionSwitch = (UISwitch *)sender;
    if ([disableAgeRestrictionSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableAgeRestriction"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableAgeRestriction"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end