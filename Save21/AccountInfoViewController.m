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


@interface AccountInfoViewController () {
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) NSString* boldFontName;
@property (nonatomic, strong) UIColor* onColor;
@property (nonatomic, strong) UIColor* dividerColor;
@property (weak, nonatomic) IBOutlet UIButton *requestChequeButton;

@property int num_of_pending_claims;
@property float account_balance;
@property float total_savings;
@property float min_amount_for_redeem;

@property BOOL redeem_cheque_enabled;
@end

@implementation AccountInfoViewController

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
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [self.view addSubview:HUD];
    
    //[HUD showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
    
    self.boldFontName = @"Avenir-Black";
    
    self.onColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:7.0/255 green:61.0/255 blue:48.0/255 alpha:1.0f];
    
    //self.onColor = [UIColor colorWithRed:222.0/255 green:59.0/255 blue:47.0/255 alpha:1.0f];
    
    self.dividerColor = [UIColor whiteColor];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.tableView.backgroundView = nil;
    
    
    self.tableView.backgroundColor = [UIColor colorWithRed:231.0/255 green:235.0/255 blue:238.0/255 alpha:1.0f];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.requestChequeButton.backgroundColor = darkColor;
    self.requestChequeButton.layer.cornerRadius = 3.0f;
    self.requestChequeButton.titleLabel.font = [UIFont fontWithName:self.boldFontName size:20.0f];
    [self.requestChequeButton setTitle:@"REQUEST CHEQUE" forState:UIControlStateNormal];
    [self.requestChequeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.requestChequeButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.flUploadEngine = [[fileUploadEngine alloc]initWithHostName:WEBSERVICE_URL customHeaderFields:nil];
}

-(void)refreshAccountInfo {
    HUD.labelText = @"Please wait";
    HUD.detailsLabelText = @"Refreshing account info...";
    [HUD show:YES];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"request_account_info",
                                       [PFUser currentUser].email, @"user_email", nil];
    self.flOperation = [self.flUploadEngine postDataToServer:postParams path:WEB_API_FILE];
    
    __weak typeof(self) weakSelf = self;
    [self.flOperation addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"Requesting user account info success!");
        //handle a successful 200 response
        NSDictionary *responseDict = [operation responseJSON];
        weakSelf.num_of_pending_claims = [[responseDict objectForKey:@"num_of_pending_claims"] intValue];
        weakSelf.account_balance = [[responseDict objectForKey:@"account_balance"] floatValue];
        weakSelf.total_savings = [[responseDict objectForKey:@"total_savings"] floatValue];
        weakSelf.min_amount_for_redeem = [[responseDict objectForKey:@"min_amount_redeem_cheque"] floatValue];
        
        if (weakSelf.account_balance >= weakSelf.min_amount_for_redeem)
            weakSelf.redeem_cheque_enabled = YES;
        else
            weakSelf.redeem_cheque_enabled = NO;
        
        [weakSelf.tableView reloadData];
        [HUD hide:YES];
    }
    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         NSLog(@"%@", error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to refresh user account info try again." delegate:weakSelf cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
         [alert show];
         [HUD hide:YES];
         
     }];
    [self.flUploadEngine enqueueOperation:self.flOperation];
}

-(void)request_cheque {
    HUD.labelText = @"Please wait";
    HUD.detailsLabelText = @"Sending cheque request...";
    [HUD show:YES];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"request_cheque",
                                       [PFUser currentUser].email, @"user_email", nil];
    self.flOperation = [self.flUploadEngine postDataToServer:postParams path:WEB_API_FILE];
    
    __weak typeof(self) weakSelf = self;
    [self.flOperation addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"Requesting cheque success!");
        //handle a successful 200 response
        [HUD hide:YES];
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
         [HUD hide:YES];
         
     }];
    [self.flUploadEngine enqueueOperation:self.flOperation];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        headerView.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0f];
    
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(30, 9, 200, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:self.boldFontName size:20.0f];
        label.textColor = self.onColor;
    
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
    cell.textLabel.font = [UIFont fontWithName:self.boldFontName size:12.0f];
    cell.detailTextLabel.font = [UIFont fontWithName:self.boldFontName size:20.0f];
    cell.detailTextLabel.textColor = self.onColor;
    
    switch (section) {
        case NameSection: {
            cell.textLabel.font = [UIFont fontWithName:self.boldFontName size:25.0f];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[PFUser currentUser] objectForKey:@"firstName"],[[PFUser currentUser] objectForKey:@"lastName"]];
            break;
        }
        case SavingsSection: {
            switch (row) {
                case ReceiptsPending:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.num_of_pending_claims];
                    break;
                case AccountBalance:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f",self.account_balance];
                    break;
                case TotalSavings:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f",self.total_savings];
                    break;
                    
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
                    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectForKey:@"City"]];
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
