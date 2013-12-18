//
//  UploadViewController.m
//  Save21
//
//  Created by Feiyang Chen on 2013-10-17.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "UploadViewController.h"
#import "singleOffer.h"
#import "keysAndUrls.h"
#import "ImagesBox.h"
#import "OffersList.h"
#import "MBProgressHUD.h"
#import "OfferTableViewDataSource.h"

#define AppIconHeight   75.0f

@interface UploadViewController () {
    //NSArray *_offers; //replaced by the singleton offerslist object
    ImagesBox *anotherBox;
    OffersList *anotherOfferBox;
    BOOL addingToreceipts_and_offers_tableSuccess;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *offersListTable;
@property (weak, nonatomic) OfferTableViewDataSource *dataSourceAndDelegate;
@property (weak, nonatomic) FetchingManagerCommunicator *communicatorEngine;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) NSString *currentReceiptID;
@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation UploadViewController

@synthesize offersListTable = _offersListTable;
@synthesize dataSourceAndDelegate = _dataSourceAndDelegate;
@synthesize communicatorEngine = _communicatorEngine;
@synthesize currentReceiptID = _currentReceiptID;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.labelText = @"Please wait";
    self.HUD.detailsLabelText = @"Uploading...";
    self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
    self.HUD.progress = 0.0f;
    
    [self.view addSubview:self.HUD];
    
    self.backButton.backgroundColor = ApplicationDelegate.darkColor;
    self.backButton.layer.cornerRadius = 3.0f;
    self.backButton.titleLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:14.0f];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.doneButton.backgroundColor = ApplicationDelegate.darkColor;
    self.doneButton.layer.cornerRadius = 3.0f;
    self.doneButton.titleLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:14.0f];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.titleLabel.textColor =  [UIColor whiteColor];
    self.titleLabel.font =  [UIFont fontWithName:ApplicationDelegate.boldFontName size:24.0f];
    
    //Link the communicator to the appdelegate's communicator
    self.communicatorEngine = ApplicationDelegate.communicator;
    self.communicatorEngine.delegate = self;
    
    //Init and set up the tableview datasource
    self.dataSourceAndDelegate = ApplicationDelegate.dataSource;
    
    [self.offersListTable setDataSource:self.dataSourceAndDelegate];
    [self.offersListTable setDelegate:self.dataSourceAndDelegate];
    
    //Initialize the Singletons variables
    anotherBox = [ImagesBox imageBox];
    anotherOfferBox = [OffersList offersList];
    
    //connect to the server to fetch for the receipt ID of this upload
    [self requestReceiptID];
    
    //by default addingToreceipts_and_offers_tableSuccess is false
    addingToreceipts_and_offers_tableSuccess = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //set the tableView datasource to show checkmarks
    [self.dataSourceAndDelegate setShowCheckMarks:YES];
    
    //refresh table
    [self.offersListTable reloadData];
    
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector(userDidSelectOfferNotification:)
     name: OfferTableDidSelectOfferNotification
     object: nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [[NSNotificationCenter defaultCenter]
     removeObserver: self name: OfferTableDidSelectOfferNotification object: nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)requestReceiptID {
    [self.communicatorEngine requestReceiptIDForUserEmail:[PFUser currentUser].email];
}

-(void)uploadImageBox {
    [self.HUD show:YES];
    
    [self.communicatorEngine uploadImages:anotherBox.imageArray forEmail:[PFUser currentUser].email andReceiptID:self.currentReceiptID];
}

-(void)addTo_receipts_and_offers_table {
    [self.communicatorEngine addTo_receipts_and_offers_table:self.currentReceiptID withOfferIDs:[self.dataSourceAndDelegate DictionaryOfSelectedOfferIDs]];
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    //be sure the user has selected at least one offer
    if ([self.dataSourceAndDelegate DictionaryOfSelectedOfferIDs].count){
        //don't let user click it twice
        [self.doneButton setEnabled:NO];
        
        //start by updating the receipts_and_offers_table
        [self addTo_receipts_and_offers_table];
        
        //next upload the photos
        [self uploadImageBox];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Must check at least one offer that applies to this receipt." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	if([title isEqualToString:@"Done"])
	{
        //clear the imagebox
        [anotherBox emptyBox];
        
		[self performSegueWithIdentifier:@"Done Uploading" sender:self];
	} else if ([title isEqualToString:@"Dismiss"]) {
        [self performSegueWithIdentifier:@"Back to PicturesView" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - From FetchingManagerCommunicatorDelegate

-(void)requestingReceiptIDFailedWithError: (NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to request a new receipt ID, please click upload to try again." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

-(void)receivedReceiptID:(NSString *)receiptID{
    NSLog(@"New receiptID is: %@",receiptID);
    if (!receiptID) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to request a new receipt ID, please click upload to try again." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    
    self.currentReceiptID = receiptID;
}

-(void)uploadImagesFailedWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Upload failed, please try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    [self.HUD hide:YES];
    [self.doneButton setEnabled:YES];
}

-(void)uploadImagesSuccess {
    if (addingToreceipts_and_offers_tableSuccess) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Receipt upload completed!" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Upload failed, please try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    [self.HUD hide:YES];
}

-(void)fileTransferOperationProgress:(double)percentage{
    self.HUD.progress = percentage;
}

-(void)addTo_receipts_and_offers_tableFailedWithError: (NSError *)error {
    addingToreceipts_and_offers_tableSuccess = NO;
}

-(void)addTo_receipts_and_offers_tableSuccess {
    addingToreceipts_and_offers_tableSuccess = YES;
}

#pragma mark - Notification handling

-(void)userDidSelectOfferNotification:(NSNotification *)note {
    singleOffer * selectedOffer = (singleOffer *)[note object];
    
    if ([[self.dataSourceAndDelegate DictionaryOfSelectedOfferIDs] objectForKey:selectedOffer.offerid] == nil)
    {
        [[self.dataSourceAndDelegate DictionaryOfSelectedOfferIDs]  setObject:@"" forKey: selectedOffer.offerid];
        
        NSLog(@"Offer %@ checked",selectedOffer.name);
    }
    else
    {
        [[self.dataSourceAndDelegate DictionaryOfSelectedOfferIDs]  removeObjectForKey:selectedOffer.offerid];
        
        NSLog(@"Offer %@ unchecked",selectedOffer.name);
    }
    
    [self.offersListTable reloadData];
}

@end
