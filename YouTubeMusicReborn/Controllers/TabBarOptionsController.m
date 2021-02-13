#import "TabBarOptionsController.h"

@implementation TabBarOptionsController

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.title = @"YouTube Music Reborn TabBar Options";
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
    static NSString *CellIdentifier = @"TabBarTableViewCell";
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
            cell.textLabel.text = @"Hide Tab Bar Labels";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideTabBarLabels = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideTabBarLabels addTarget:self action:@selector(toggleHideTabBarLabels:) forControlEvents:UIControlEventValueChanged];
            hideTabBarLabels.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBarLabels"];
            cell.accessoryView = hideTabBarLabels;
        }
        if(indexPath.row == 1) {
            cell.textLabel.text = @"Hide Explore Tab";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideExploreTab = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideExploreTab addTarget:self action:@selector(toggleHideExploreTab:) forControlEvents:UIControlEventValueChanged];
            hideExploreTab.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideExploreTab"];
            cell.accessoryView = hideExploreTab;
        }
        if(indexPath.row == 2) {
            cell.textLabel.text = @"Hide Library Tab";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideLibraryTab = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideLibraryTab addTarget:self action:@selector(toggleHideLibraryTab:) forControlEvents:UIControlEventValueChanged];
            hideLibraryTab.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideLibraryTab"];
            cell.accessoryView = hideLibraryTab;
        }
        if(indexPath.row == 3) {
            cell.textLabel.text = @"Hide Upgrade Tab";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideUpgradeTab = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideUpgradeTab addTarget:self action:@selector(toggleHideUpgradeTab:) forControlEvents:UIControlEventValueChanged];
            hideUpgradeTab.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideUpgradeTab"];
            cell.accessoryView = hideUpgradeTab;
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

@implementation TabBarOptionsController(Privates)

- (void)done
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Closed TabBarOptionsController");
    }];
}

- (void)toggleHideTabBarLabels:(UISwitch*)sender
{
    UISwitch *hideTabBarLabelsSwitch = (UISwitch *)sender;
    if ([hideTabBarLabelsSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideTabBarLabels"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideTabBarLabels"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideExploreTab:(UISwitch*)sender
{
    UISwitch *hideExploreTabSwitch = (UISwitch *)sender;
    if ([hideExploreTabSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideExploreTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideExploreTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideLibraryTab:(UISwitch*)sender
{
    UISwitch *hideLibraryTabSwitch = (UISwitch *)sender;
    if ([hideLibraryTabSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideLibraryTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideLibraryTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideUpgradeTab:(UISwitch*)sender
{
    UISwitch *hideUpgradeTabSwitch = (UISwitch *)sender;
    if ([hideUpgradeTabSwitch isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideUpgradeTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideUpgradeTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end