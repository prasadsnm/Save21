//
//  OffersListViewController.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "OffersListViewController.h"
#import "OfferViewController.h"
#import "singleOffer.h"
#import "FetchingManager.h"
#import "keysAndUrls.h"
#import "OffersList.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

static Reachability *_reachability = nil;
BOOL _reachabilityOn;

static inline Reachability* defaultReachability () {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reachability = [Reachability reachabilityForInternetConnection];
    });
    
    return _reachability;
}

#define AppIconHeight    75.0f  //the icon size for table cell image

@interface OffersListViewController () <FetchingManagerDelegate> {
    OffersList *offersBox;
    
    long indexOfSelectedCell;
    
    MBProgressHUD *HUD;
    
    NSMutableArray *arrayOfBannersImageURLs;
    NSMutableArray *arrayOfBannersTitles;
    NSMutableArray *arrayOfBannersOfferIDs;
    NSMutableArray *arrayOfBannersOfferURLs;
    
    NSString *offerIDForSegue;
    NSString *offerURLForSegue;
    
    BOOL connected;
    BOOL needsToRefresh;
}

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (strong, nonatomic) IBOutlet AOScrollerView *scrollPictureView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;

@end

@implementation OffersListViewController
@synthesize offersListTable = _offersListTable;
@synthesize dataSourceAndDelegate = _dataSourceAndDelegate;
@synthesize revealController;
@synthesize warningLabel = _warningLabel;
@synthesize scrollPictureView = _scrollPictureView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    connected = YES;
    
    //initialize the slider bar menu button
    UIButton* menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 20)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    menuButton.tintColor = [UIColor colorWithRed:7.0/255 green:61.0/255 blue:48.0/255 alpha:1.0f];
    [menuButton addTarget:self action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuItem;
    
    //initialize the progress HUD
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"Please wait";
    HUD.detailsLabelText = @"Refreshing offers list...";
    HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:HUD];
    
    self.offersListTable.backgroundColor = [UIColor whiteColor];
    self.offersListTable.separatorColor = [UIColor colorWithWhite:0.9 alpha:0.6];
    
    //Initialize the Singleton OffersList variable
    offersBox = [OffersList offersList];
    
    //Init and set up the tableview datasource
    self.dataSourceAndDelegate = ApplicationDelegate.dataSource;
    
    [self.offersListTable setDataSource:self.dataSourceAndDelegate];
    [self.offersListTable setDelegate:self.dataSourceAndDelegate];
    
    //link the fetchManager to the one in ApplicationDelegate
    ApplicationDelegate.manager.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //set the tableView datasource to NOT show checkmarks
    [self.dataSourceAndDelegate setShowCheckMarks:NO];
    
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector(userDidSelectOfferNotification:)
     name: OfferTableDidSelectOfferNotification
     object: nil];
    
    
    needsToRefresh = NO;
    
    [self startFetchingOffers];
    [self startInternetReachability];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    
    [self stopInternerReachability];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver: self name: OfferTableDidSelectOfferNotification object: nil];
}

//slide out the slider bar
- (void)revealToggle:(id)sender {
    [self.revealController toggleSidebar:!self.revealController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

//fetch offers list from either cache or internet
- (void)startFetchingOffers
{
    [HUD show:YES];
    
    needsToRefresh = NO;
    //fetch from offers
    [ApplicationDelegate.manager fetchOffers];
}

-(void)showNoInternetWarning {
    self.labelHeight.constant = 35;
    
    [self animateConstraints];
}

-(void)removeNoInternetWarning {
    self.labelHeight.constant = 0;
    
    [self animateConstraints];
}

- (void)animateConstraints
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"Go to camera view"]) {
        if (connected)
            return YES;
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Take picture" message: @"It appears you are not online. This functions requires that you are online in order to use it. Please connect to internet and try again." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"show Offer"]) {
        [segue.destinationViewController setOfferPageID:offerIDForSegue];
        [segue.destinationViewController setOfferPageURL:offerURLForSegue];
    }
}

#pragma mark - From FetchingManagerCommunicatorDelegate

- (void)didReceiveOffers:(NSArray *)offers
{
    //send the received offers to the OffersList singleton for storage
    [offersBox initializeOffersList:offers];
    
    //set up the banner view
    arrayOfBannersImageURLs = nil;
    arrayOfBannersTitles = nil;
    arrayOfBannersOfferIDs = nil;
    arrayOfBannersOfferURLs = nil;
    
    arrayOfBannersImageURLs = [[NSMutableArray alloc] init];
    arrayOfBannersTitles = [[NSMutableArray alloc] init];
    arrayOfBannersOfferIDs = [[NSMutableArray alloc] init];
    arrayOfBannersOfferURLs = [[NSMutableArray alloc] init];
    
    for (singleOffer *offer in offersBox.offersArray) {
        if ([offer.properties isEqualToString:@"banner"]) {
            [arrayOfBannersImageURLs addObject:[NSString stringWithFormat:@"%@%@", IMAGE_FOLDER_URL, offer.bannerPictureURL]];
            [arrayOfBannersTitles addObject:offer.name];
            [arrayOfBannersOfferIDs addObject:offer.offerid];
            [arrayOfBannersOfferURLs addObject:offer.offerurl];
        }
        //NSLog(@"%@",[NSString stringWithFormat:@"%@%@", IMAGE_FOLDER_URL, offer.bannerPictureURL]);
    }
    
    //remove the old scroll view if it exists
    if ([self.scrollPictureView isKindOfClass:[AOScrollerView class]]) {
        [self.scrollPictureView removeFromSuperview];
    }
    
    //initialize the banner view
    self.scrollPictureView = [[AOScrollerView alloc]initWithNameArr:arrayOfBannersImageURLs titleArr:arrayOfBannersTitles height:150];
    
    self.scrollPictureView.vDelegate=self;
    
    //add banner to top of table
    self.offersListTable.tableHeaderView = self.scrollPictureView;
    
    //hide the waiting pop up
    [HUD hide:YES];
    
    //send the received offers data to tableview's datasource
    [self.dataSourceAndDelegate setOffers:offers];
    
    [self.offersListTable reloadData];
}

-(void)failedToReceiveOffersWithError:(NSError *)error {
    [self showNoInternetWarning];
    connected = NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't get the lastest offers from server, please check internet connectivity and try again later." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    
    //hide the waiting pop up
    [HUD hide:YES];
}

#pragma mark tableview data source Notification handling

-(void)userDidSelectOfferNotification:(NSNotification *)note {
    singleOffer * selectedOffer = (singleOffer *)[note object];
     
    offerIDForSegue = selectedOffer.offerid;
    offerURLForSegue = selectedOffer.offerurl;
     
    NSLog(@"Offer ID %@ to segue",offerIDForSegue);
    NSLog(@"Offer URL %@ to segue",offerURLForSegue);
     
    [self performSegueWithIdentifier:@"show Offer" sender: self];
}


#pragma AOScrollViewDelegate
-(void)buttonClick:(int)vid{
    //NSLog(@"%@",arrayOfBannersOfferIDs[vid]);
    offerIDForSegue = arrayOfBannersOfferIDs[vid];
    offerURLForSegue = arrayOfBannersOfferURLs[vid];
    
    [self performSegueWithIdentifier:@"show Offer" sender:self];
}

#pragma mark Reachability Notification Handling
- (void)checkNetworkStatus {
    // called after network status changes
    NetworkStatus internetStatus = [defaultReachability() currentReachabilityStatus];
    switch (internetStatus) {
            
        case NotReachable: {
            NSLog(@"Unreachable");
            [self performSelector:@selector(showNoInternetWarning) withObject:nil afterDelay:0.1]; // performed with a small delay to avoid multiple notification causing stange jumping
            connected = NO;
            needsToRefresh = YES;
            
            break;
        }
            
        case ReachableViaWiFi:
        case ReachableViaWWAN: {
            NSLog(@"Reachable");
            [self performSelector:@selector(removeNoInternetWarning) withObject:nil afterDelay:0.1]; // performed with a small delay to avoid multiple notification causing stange jumping
            connected = YES;
            
            if (needsToRefresh)
                [self startFetchingOffers];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)startInternetReachability {
    
    if (!_reachabilityOn) {
        _reachabilityOn = TRUE;
        [defaultReachability() startNotifier];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus) name:kReachabilityChangedNotification object:nil];
    
    [self checkNetworkStatus];
}

- (void)stopInternerReachability {
    
    _reachabilityOn = FALSE;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
@end
