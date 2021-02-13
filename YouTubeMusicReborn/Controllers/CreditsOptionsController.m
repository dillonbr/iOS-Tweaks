#import "CreditsOptionsController.h"

@implementation CreditsOptionsController

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.title = @"YouTube Music Reborn Credits";
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 1;
    }
    if(section == 1) {
        return 2;
    }
    if(section == 2) {
        return 2;
    }
    if(section == 3) {
        return 11;
    }
    return 0;
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
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        if(indexPath.section == 1) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"SarahH12099";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 1) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        if(indexPath.section == 2) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Alpha_Stream";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 1) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        if(indexPath.section == 3) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Cameren";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 1) {
                cell.textLabel.text = @"Capt Inc";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 2) {
                cell.textLabel.text = @"Carlos C";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 3) {
                cell.textLabel.text = @"Hayden";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 4) {
                cell.textLabel.text = @"Kabir";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 5) {
                cell.textLabel.text = @"Luki120";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 6) {
                cell.textLabel.text = @"MTAC";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 7) {
                cell.textLabel.text = @"n3d";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 8) {
                cell.textLabel.text = @"PJ09";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 9) {
                cell.textLabel.text = @"Swaggo";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 10) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/SarahH12099"] options:@{} completionHandler:nil];
        }
    }
    if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/Kutarin_"] options:@{} completionHandler:nil];
        }
    }
    if(indexPath.section == 3) {
        if(indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/1D0nt3venKnow"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/captinc"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 2) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/KoukoCarlos"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 3) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/Diatrus"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 4) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/kabiroberai"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 5) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/Lukii120"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 6) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/MTAC8"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 7) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/45h20"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 8) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/PJZeroNine"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 9) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/Swaggggggo"] options:@{} completionHandler:nil];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Developer";
    }
    if (section == 2) {
        return @"Icon Designer";
    }
    if (section == 3) {
        return @"Special Thanks";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
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
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tableSection"]]];
    [header.textLabel setFont:[UIFont systemFontOfSize:14]];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return @"Footer";
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
    [footer.textLabel setTextColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1) {
        return 15.0;
    }
    if(section == 2) {
        return 15.0;
    }
    if(section == 3) {
        return 15.0;
    }
    return 0;
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

@implementation CreditsOptionsController(Privates)

- (void)done
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Closed CreditsOptionsController");
    }];
}

@end