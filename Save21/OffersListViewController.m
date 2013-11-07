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

#define AppIconHeight    75.0f

@interface OffersListViewController () <FetchingManagerDelegate,MHLazyTableImagesDelegate> {
    FetchingManager *_manager;
    OffersList *offersBox;
    
    int indexOfSelectedCell;
    
    MHLazyTableImages *_lazyImages;
    
    MBProgressHUD *HUD;
    
    NSMutableArray *arrayOfBannersImageURLs;
    NSMutableArray *arrayOfBannersTitles;
    NSMutableArray *arrayOfBannersURLs;
    
    NSString *offerURLStringForSegue;
    
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
    
    [HUD show:YES];
    
    self.offersListTable.backgroundColor = [UIColor whiteColor];
    self.offersListTable.separatorColor = [UIColor colorWithWhite:0.9 alpha:0.6];
    
    //Initialize the Singleton OffersList variable
    offersBox = [OffersList offersList];
    
    _manager = [[FetchingManager alloc] init];
    _manager.flUploadEngine = [[fileUploadEngine alloc] initWithHostName:WEBSERVICE_URL customHeaderFields:nil];
    _manager.delegate = self;
    
    [self.offersListTable setDataSource:self];
    [self.offersListTable setDelegate:self];
    
    _lazyImages.tableView = self.offersListTable;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Add Observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    
    [self startFetchingOffers];
}

- (void)revealToggle:(id)sender {
    [self.revealController toggleSidebar:!self.revealController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

- (void)startFetchingOffers
{
    [_manager fetchOffers];
}

- (void)didReceiveOffers:(NSArray *)offers
{
    [self removeNoInternetWarning];
    connected = YES;
    
    offersBox.offersArray = offers;
    
    arrayOfBannersImageURLs = nil;
    arrayOfBannersTitles = nil;
    arrayOfBannersURLs = nil;
    
    arrayOfBannersImageURLs = [[NSMutableArray alloc] init];
    arrayOfBannersTitles = [[NSMutableArray alloc] init];
    arrayOfBannersURLs = [[NSMutableArray alloc] init];
    
    for (singleOffer *offer in offersBox.offersArray) {
        
        if ([offer.properties isEqualToString:@"banner"]) {
            [arrayOfBannersImageURLs addObject:[NSString stringWithFormat:@"%@%@", IMAGE_FOLDER_URL, offer.bannerPictureURL]];
            [arrayOfBannersTitles addObject:offer.name];
            [arrayOfBannersURLs addObject:offer.offerurl];
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
    offerURLStringForSegue = selectedOffer.offerurl;
    NSLog(@"%@",offerURLStringForSegue);
    
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
    cell.commentCountLabel.text = [NSString stringWithFormat:@"$%.2f",currentOffer.rebate_amount];
    
    if (currentOffer.num_left == -1)
        cell.dateLabel.text = [NSString stringWithFormat:@"Unlimited"];
    else
        cell.dateLabel.text = [NSString stringWithFormat:@"Remaining: %d",currentOffer.num_left];
    
	[_lazyImages addLazyImageForCell:cell withIndexPath:indexPath];
    
	return cell;
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
        [segue.destinationViewController setUrlString:offerURLStringForSegue];
    }
}

#pragma AOScrollViewDelegate
-(void)buttonClick:(int)vid{
    NSLog(@"%@",arrayOfBannersURLs[vid]);
    offerURLStringForSegue = arrayOfBannersURLs[vid];
    
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
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable] || [reachability isReachableViaWWAN] || [reachability isReachableViaWiFi]) {
        NSLog(@"Reachable");
        [self removeNoInternetWarning];
        connected = YES;
        [HUD show:YES];
        [self startFetchingOffers];
    } else {
        NSLog(@"Unreachable");
        [self showNoInternetWarning];
        connected = NO;
    }
}
@end
