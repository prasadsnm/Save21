//
//  AccountInfoViewController.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-10.
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
    HUD.labelText = @"Please wait";
    HUD.detailsLabelText = @"Refreshing account info...";
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
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    PFUser *thisUser = [PFUser currentUser];
    
    [HUD show:YES];
        
    [thisUser refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [NSThread sleepForTimeInterval:1.0f]; //simulate loading time
        
        if (object) {
            NSLog(@"User profile info refresh complete.");
            [HUD hide:YES];
        } else {
            if (error) {
                NSLog(@"PROBLEM: %@", [error userInfo][@"error"]);
                if ([error code] == kPFErrorConnectionFailed) {
                    UIAlertView *alert;
                    alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"It appears you are not online. Please connect to internet and revisit this page to refresh." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                    [alert show];
                } else if (error) {
                    NSLog(@"Error: %@", [error userInfo][@"error"]);
                }
                [HUD hide:YES];
            }
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (IBAction)requestChequeButtonPressed:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: REQUEST_CHEQUE_PAGE_URL]];
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
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[PFUser currentUser] objectForKey:@"numberOfReceiptsInProcess"]];
                    break;
                case AccountBalance:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f",[[[PFUser currentUser] objectForKey:@"accountBalance"] doubleValue]];
                    break;
                case TotalSavings:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f",[[[PFUser currentUser] objectForKey:@"totalSaved"] doubleValue]];
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
