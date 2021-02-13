#import "ColourOptionsController.h"

@implementation ColourOptionsController

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.title = @"YouTube Reborn Colour Options";
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

    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;

    self.supportsAlpha = YES;
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    UIColor *color = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    self.selectedColor = color;
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

@implementation ColourOptionsController(Privates)

UIWindow *alertWindowOutSaved;

- (void)done
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Closed ColourOptionsController");
    }];
}

- (void)save
{
    NSLog(@"%@", self.selectedColor);
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:self.selectedColor requiringSecureCoding:nil error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"kColourOptions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Saved Colour");
    UIWindow *alertWindowSaved = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindowSaved.rootViewController = [UIViewController new];
    alertWindowSaved.windowLevel = UIWindowLevelAlert + 1;
    alertWindowOutSaved = alertWindowSaved;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Colour Saved" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        alertWindowSaved.hidden = YES;
    }]];

    [alertWindowSaved makeKeyAndVisible];
    [alertWindowSaved.rootViewController presentViewController:alert animated:YES completion:nil];
    NSLog(@"Popup Appeared");
}

@end