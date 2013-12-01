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
#import "MHLazyTableImages.h"
#import "MBProgressHUD.h"
#import "OfferTableCell.h"
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

#define AppIconHeight    75.0f

@interface OffersListViewController () <FetchingManagerDelegate,MHLazyTableImagesDelegate> {
    FetchingManager *_manager;
    OffersList *offersBox;
    
    long indexOfSelectedCell;
    
    MHLazyTableImages *_lazyImages;
    
    MBProgressHUD *HUD;
    
    NSMutableArray *arrayOfBannersImageURLs;
    NSMutableArray *arrayOfBannersTitles;
    NSMutableArray *arrayOfBannersOfferIDs;
    NSMutableArray *arrayOfBannersOfferURLs;
    
    NSString *offerIDForSegue;
    NSString *offerURLForSegue;
    
    BOOL connected;
}

@property (weak, nonatomic) IBOutlet UITableView *offersListTable;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (strong, nonatomic) IBOutlet AOScrollerView *scrollPictureView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;

@end

@implementation OffersListViewController

@synthesize revealController;
@synthesize offersListTable = _offersListTable;
@synthesize warningLabel = _warningLabel;
@synthesize scrollPictureView = _scrollPictureView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		_lazyImages = [[MHLazyTableImages alloc] init];
		_lazyImages.placeholderImage = [UIImage imageNamed:@"Placeholder"];
		_lazyImages.delegate = self;
	}
	return self;
}

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
    
    [self.offersListTable setDataSource:self];
    [self.offersListTable setDelegate:self];
    
    _lazyImages.tableView = self.offersListTable;
    
    
    _manager = [[FetchingManager alloc] init];
    _manager.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startInternetReachability];
    [self startFetchingOffers];
}


//slide out the slider bar
- (void)revealToggle:(id)sender {
    [self.revealController toggleSidebar:!self.revealController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

//fetch offers list from either cache or internet
- (void)startFetchingOffers
{
    [HUD show:YES];
    //fetch from offers
    [_manager fetchOffers];
}

- (void)didReceiveOffers:(NSArray *)offers withBatchID:(NSString *)batchID
{
    
    [self removeNoInternetWarning];
    connected = YES;
    
    NSLog(@"Got offer batch hash: %@",batchID);
    
    offersBox.offersArray = offers;
    
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
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
        
        [self.offersListTable reloadData];
    });
}

-(void)failedToReceiveOffers {
    [self showNoInternetWarning];
    connected = NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't get the lastest offers from server, please check internet connectivity and try again later." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    
    //hide the waiting pop up
    [HUD hide:YES];
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
    _lazyImages.tableView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return offersBox.offersArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    indexOfSelectedCell = indexPath.row;
    
    singleOffer *selectedOffer = offersBox.offersArray[indexOfSelectedCell];
    
    offerIDForSegue = selectedOffer.offerid;
    offerURLForSegue = selectedOffer.offerurl;
    
    NSLog(@"Offer ID %@ to segue",offerIDForSegue);
    NSLog(@"Offer URL %@ to segue",offerURLForSegue);
    
    [self performSegueWithIdentifier:@"show Offer" sender: self];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([offersBox.offersArray count] == 0)
	{
		return [self placeholderCell];
	}
	else
	{
		return [self recordCellForIndexPath:indexPath];
	}
}

- (UITableViewCell *)placeholderCell
{
	static NSString *CellIdentifier = @"offerCell";
    
	OfferTableCell *cell = [self.offersListTable dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[OfferTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
	cell.nameLabel.text = @"Loading…";
	return cell;
}

- (UITableViewCell *)recordCellForIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"offerCell";
    
	OfferTableCell *cell = [self.offersListTable dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[OfferTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
    singleOffer *currentOffer = offersBox.offersArray[indexPath.row];
    
    cell.nameLabel.text = currentOffer.name;
	cell.updateLabel.text = currentOffer.description;
    cell.commentCountLabel.text = [NSString stringWithFormat:@"$%.2f",[currentOffer.rebate_amount floatValue]];
    
    if ([currentOffer.total_offered intValue] == -1)
        cell.dateLabel.text = [NSString stringWithFormat:@"Unlimited"];
    else {
        if ( ( [currentOffer.total_offered intValue] - [currentOffer.num_of_valid_claims intValue] ) < 1 )
            cell.dateLabel.text = @"SOLD OUT";
        else
            cell.dateLabel.text = [NSString stringWithFormat:@"Remaining: %d",([currentOffer.total_offered intValue] - [currentOffer.num_of_valid_claims intValue] )];
    }
    
	[_lazyImages addLazyImageForCell:cell withIndexPath:indexPath];
    
	return cell;
}

-(void)refreshTableView {
    [self.offersListTable reloadData];
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

#pragma AOScrollViewDelegate
-(void)buttonClick:(int)vid{
    //NSLog(@"%@",arrayOfBannersOfferIDs[vid]);
    offerIDForSegue = arrayOfBannersOfferIDs[vid];
    offerURLForSegue = arrayOfBannersOfferURLs[vid];
    
    [self performSegueWithIdentifier:@"show Offer" sender:self];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_lazyImages scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[_lazyImages scrollViewDidEndDecelerating:scrollView];
}

#pragma mark - MHLazyTableImagesDelegate

- (NSURL *)lazyTableImages:(MHLazyTableImages *)lazyTableImages lazyImageURLForIndexPath:(NSIndexPath *)indexPath
{
	singleOffer *currentOffer = offersBox.offersArray[indexPath.row];
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_FOLDER_URL,currentOffer.pictureURL]];
}

- (UIImage *)lazyTableImages:(MHLazyTableImages *)lazyTableImages postProcessLazyImage:(UIImage *)image forIndexPath:(NSIndexPath *)indexPath
{
    if (image.size.width != AppIconHeight && image.size.height != AppIconHeight)
 		return [self scaleImage:image toSize:CGSizeMake(AppIconHeight, AppIconHeight)];
    else
        return image;
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
	UIGraphicsBeginImageContextWithOptions(size, YES, 0.0f);
	CGRect imageRect = CGRectMake(0.0f, 0.0f, size.width, size.height);
	[image drawInRect:imageRect];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

#pragma mark Notification Handling
- (void)checkNetworkStatus {
    // called after network status changes
    NetworkStatus internetStatus = [defaultReachability() currentReachabilityStatus];
    switch (internetStatus) {
            
        case NotReachable: {
            NSLog(@"Unreachable");
            [self performSelector:@selector(showNoInternetWarning) withObject:nil afterDelay:0.1]; // performed with a small delay to avoid multiple notification causing stange jumping
            connected = NO;
            break;
        }
            
        case ReachableViaWiFi:
        case ReachableViaWWAN: {
            NSLog(@"Reachable");
            [self performSelector:@selector(removeNoInternetWarning) withObject:nil afterDelay:0.1]; // performed with a small delay to avoid multiple notification causing stange jumping
            connected = YES;
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
