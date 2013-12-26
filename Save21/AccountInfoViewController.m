//
//  AccountInfoViewController.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-10.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "MBProgressHUD.h"
#import "keysAndUrls.h"
#import "OffersListRootController.h"

@interface AccountInfoViewController () {
    BOOL refreshed;
}
@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) UIColor* onColor;
@property (nonatomic, strong) UIColor* dividerColor;
@property (weak, nonatomic) IBOutlet UIButton *requestChequeButton;

@property int num_of_pending_claims;
@property float account_balance;
@property float total_savings;
@property float min_amount_for_redeem;

@property BOOL redeem_cheque_enabled;

@property (weak, nonatomic) FetchingManagerCommunicator *communicatorEngine;

@property (strong, nonatomic) MKNetworkOperation *flOperation; //to be removed later

@end

@implementation AccountInfoViewController
@synthesize communicatorEngine = _communicatorEngine;
@synthesize HUD = _HUD;
@synthesize flOperation = _flOperation; //to be removed later

enum AccountInfoPageSections {
    NameSection = 0,
    SavingsSection = 1,
    AboutYouSection = 2
};

enum SavingsSectionRows {
    ReceiptsPending = 0,
    AccountBalance = 1,
    TotalSavings = 2
};

enum AboutMe {
    UserEmail = 0,
    UserCity = 1
};

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
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [self.view addSubview:self.HUD];
    
    self.onColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    
    self.dividerColor = [UIColor whiteColor];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.tableView.backgroundView = nil;
    
    
    self.tableView.backgroundColor = [UIColor colorWithRed:231.0/255 green:235.0/255 blue:238.0/255 alpha:1.0f];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.requestChequeButton.backgroundColor = ApplicationDelegate.darkColor;
    self.requestChequeButton.layer.cornerRadius = 3.0f;
    self.requestChequeButton.titleLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:20.0f];
    [self.requestChequeButton setTitle:@"REQUEST CHEQUE" forState:UIControlStateNormal];
    [self.requestChequeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.requestChequeButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    //Link the communicator to the appdelegate's communicator
    self.communicatorEngine = ApplicationDelegate.communicator;
    self.communicatorEngine.delegate = self;
    
    //make the balance amount a - instead of 0 at the start
    refreshed = NO;
}

- (void)goback
{
    [self performSegueWithIdentifier:@"backToMenu" sender:self];
}

-(void)refreshAccountInfo {
    self.HUD.labelText = @"Please wait";
    self.HUD.detailsLabelText = @"Refreshing account info...";
    [self.HUD show:YES];
    
    [self.communicatorEngine refreshUserInfo:[PFUser currentUser].email];
}

//this is only for demo, it is more likely the cheque request to server will be sent from the actual website than the app itself, therefore this function will not be refactored into the FetchingManagerCommunicator
-(void)request_cheque {
    self.HUD.labelText = @"Please wait";
    self.HUD.detailsLabelText = @"Sending cheque request...";
    [self.HUD show:YES];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"request_cheque",
                                       [PFUser currentUser].email, @"user_email", nil];
    self.flOperation = [ApplicationDelegate.communicator postDataToServer:postParams path:WEB_API_FILE];
    
    __weak typeof(self) weakSelf = self;
    [self.flOperation addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"Requesting cheque success!");
        //handle a successful 200 response
        [weakSelf.HUD hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have successfully request the cheque." delegate:weakSelf cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        
    }
    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
         NSLog(@"%@", error);
         //user already requested cheque
         if (error.code == 409) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have already requested a cheque." delegate:weakSelf cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
             [alert show];
         } else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to request cheque, please try again." delegate:weakSelf cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
             [alert show];
         }
         [weakSelf.HUD hide:YES];
         
     }];
    [ApplicationDelegate.communicator enqueueOperation:self.flOperation];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshAccountInfo];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (IBAction)requestChequeButtonPressed:(UIButton *)sender {
    if (!self.redeem_cheque_enabled) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"This account doesn't have enough balance to request a cheque yet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];

    } else {
        [self request_cheque];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview set up

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        headerView.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0f];
    
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(30, 9, 200, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:20.0f];
        label.textColor = ApplicationDelegate.darkColor;
    
        label.text = section == 1 ? @"You Savings" : @"User Information";
    
        [headerView addSubview:label];
    
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return 0;
    return 50;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    cell.textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:12.0f];
    cell.detailTextLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:20.0f];
    cell.detailTextLabel.textColor = ApplicationDelegate.darkColor;
    
    switch (section) {
        case NameSection: {
            cell.textLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:25.0f];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[PFUser currentUser] objectForKey:@"firstName"],[[PFUser currentUser] objectForKey:@"lastName"]];
            break;
        }
        case SavingsSection: {
            switch (row) {
                case ReceiptsPending:
                    if (refreshed)
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.num_of_pending_claims];
                    else
                        cell.detailTextLabel.text = @"-";
                    
                    break;
                case AccountBalance:
                    if (refreshed)
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f",self.account_balance];
                    else
                        cell.detailTextLabel.text = @"-";
                    
                    break;
                case TotalSavings:
                    if (refreshed)
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f",self.total_savings];
                    else
                        cell.detailTextLabel.text = @"-";
                    
                default:
                    break;
            }
            break;
        }
        case AboutYouSection: {
            switch (row) {
                case UserEmail:
                    cell.textLabel.text = [NSString stringWithFormat:@"%@", [PFUser currentUser].email];
                    break;
                case UserCity:
                    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectForKey:@"city"]];
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - From FetchingManagerCommunicatorDelegate

-(void)receivedUserInfoFailedWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to refresh user account info try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    
    [self.HUD hide:YES];
}

-(void)receivedUserInfo:(NSDictionary *)userInfo {
    refreshed = YES;
    
    self.num_of_pending_claims = [[userInfo objectForKey:@"num_of_pending_claims"] intValue];
    self.account_balance = [[userInfo objectForKey:@"account_balance"] floatValue];
    self.total_savings = [[userInfo objectForKey:@"total_savings"] floatValue];
    self.min_amount_for_redeem = [[userInfo objectForKey:@"min_amount_redeem_cheque"] floatValue];
    
    if (self.account_balance >= self.min_amount_for_redeem)
        self.redeem_cheque_enabled = YES;
    else
        self.redeem_cheque_enabled = NO;
    
    [self.tableView reloadData];
    
    [self.HUD hide:YES];
}

@end
