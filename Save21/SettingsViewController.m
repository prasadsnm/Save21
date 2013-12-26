//
//  SettingsViewController.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-10.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "SettingsViewController.h"
#import "OffersListRootController.h"
#import "keysAndUrls.h"

@interface SettingsViewController () {
    NSUserDefaults *defaults;
}

@property (nonatomic, strong) UIColor* onColor;

@property (nonatomic, strong) UIColor* offColor;

@property (nonatomic, strong) UIColor* dividerColor;

@property (weak, nonatomic) IBOutlet UILabel *weeklyOfferLabel;

@property (weak, nonatomic) IBOutlet UILabel *specialOfferLabel;

@property (weak, nonatomic) IBOutlet UISwitch *weeklySwitch;

@property (weak, nonatomic) IBOutlet UISwitch *specialOfferSwitch;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    
    //create the back button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"Back.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 32, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.onColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    
    self.offColor = [UIColor colorWithRed:242.0/255 green:228.0/255 blue:227.0/255 alpha:1.0];
    
    self.dividerColor = [UIColor whiteColor];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.tableView.backgroundView = nil;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:231.0/255 green:235.0/255 blue:238.0/255 alpha:1.0f];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.weeklyOfferLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0f];
    self.weeklyOfferLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:12.0f];
    
    self.specialOfferLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0f];
    self.specialOfferLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:12.0f];
    
    self.logoutButton.backgroundColor = ApplicationDelegate.darkColor;
    self.logoutButton.layer.cornerRadius = 3.0f;
    self.logoutButton.titleLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:20.0f];
    [self.logoutButton setTitle:@"LOG OUT" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    defaults = [NSUserDefaults standardUserDefaults];
}

- (void)goback
{
    [self performSegueWithIdentifier:@"backToMenu" sender:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([defaults boolForKey:@"receiveWeeklyOffer"])
        [self.weeklySwitch setOn:YES animated:animated];
    else
        [self.weeklySwitch setOn:NO animated:animated];
    
    if ([defaults boolForKey:@"receiveSpecialOffer"])
        [self.specialOfferSwitch setOn:YES animated:animated];
    else
        [self.specialOfferSwitch setOn:NO animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)weeklyOfferChanged:(UISwitch *)sender {
    [defaults setBool:sender.on forKey:@"receiveWeeklyOffer"];
    NSLog(@"'receiveWeeklyOffer' set to %hhd in UserDefaults",sender.on);
    [defaults synchronize];
}

- (IBAction)specialOfferChanged:(UISwitch *)sender {
    [defaults setBool:sender.on forKey:@"receiveSpecialOffer"];
    NSLog(@"'receiveSpecialOffer' set to %hhd in UserDefaults",sender.on);
    [defaults synchronize];
}

//log off and go back to login screen
- (IBAction)logOutButtonPressed:(UIButton *)sender {
    [PFUser logOut];
    
    [self performSegueWithIdentifier:@"backToSignin" sender:self];
}

-(void)OpenLink:(NSString *)link {
    NSString* launchUrl = link;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"backToMenu"]) {
        [segue.destinationViewController setShouldShowSliderBarAtStart:YES];
    }
}

#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 ) {
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        headerView.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0f];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(30, 9, 200, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:20.0f];
        label.textColor = ApplicationDelegate.darkColor;
        
        label.text = @"Settings";
        
        [headerView addSubview:label];
        
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:12.0f];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    enum SettingsPageCells {
        ResetPasswordCell = 0,
        PrivacyPageCell = 1,
        TermOfServiceCell = 2
    };
    
    NSUInteger row = [indexPath row];
    
    switch (row) {
        case ResetPasswordCell: {
            [PFUser requestPasswordResetForEmailInBackground:[PFUser currentUser].email block:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Email Sent", nil) message:NSLocalizedString(@"Please now go to your email box to reset your password using our email.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                } else {
                    NSString *errorMessage;
                    if ([error code] == kPFErrorUserWithEmailNotFound) {
                        errorMessage = @"A user with the specified email was not found";
                    } else if ([error code] == kPFErrorConnectionFailed) {
                        errorMessage = @"It appears you are not online. This app requires that you are online in order to use it. Please connect to internet and try again.";
                    } else if (error) {
                        errorMessage = [error userInfo][@"error"];
                    }
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
                }
            }];
            break;
        }
        case PrivacyPageCell: {
            [self OpenLink:PRIVACY_PAGE_URL];
            break;
        }
        case TermOfServiceCell: {
            [self OpenLink:TERMS_OF_SERVICE_PAGE_URL];
            break;
        }
        default:
            break;
    }
}

@end
