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
#import "OfferTableCell.h"

#define AppIconHeight   75.0f

@interface UploadViewController () {
    //NSArray *_offers; //replaced by the singleton offerslist object
    ImagesBox *anotherBox;
    OffersList *anotherOfferBox;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *offersListTable;
@property (strong, nonatomic) NSMutableDictionary *DictionaryOfSelectedOfferIDs;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) NSString *currentReceiptID;
@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation UploadViewController

@synthesize offersListTable = _offersListTable;
@synthesize DictionaryOfSelectedOfferIDs = _DictionaryOfSelectedOfferIDs;
@synthesize flOperation = _flOperation;
@synthesize currentReceiptID = _currentReceiptID;

-(NSMutableDictionary *)DictionaryOfSelectedOfferIDs {
    if (_DictionaryOfSelectedOfferIDs == nil) _DictionaryOfSelectedOfferIDs = [[NSMutableDictionary alloc] init];
    return _DictionaryOfSelectedOfferIDs;
}

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
    
    UIColor* darkColor = [UIColor colorWithRed:7.0/255 green:61.0/255 blue:48.0/255 alpha:1.0f];
    
    NSString* boldFontName = @"Avenir-Black";
    
    self.backButton.backgroundColor = darkColor;
    self.backButton.layer.cornerRadius = 3.0f;
    self.backButton.titleLabel.font = [UIFont fontWithName:boldFontName size:14.0f];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.doneButton.backgroundColor = darkColor;
    self.doneButton.layer.cornerRadius = 3.0f;
    self.doneButton.titleLabel.font = [UIFont fontWithName:boldFontName size:14.0f];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.titleLabel.textColor =  [UIColor whiteColor];
    self.titleLabel.font =  [UIFont fontWithName:boldFontName size:24.0f];
    
    [self.offersListTable setDataSource:self];
    [self.offersListTable setDelegate:self];
    
    anotherBox = [ImagesBox imageBox];
    anotherOfferBox = [OffersList offersList];
    
    [self requestReceiptID];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return anotherOfferBox.offersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([anotherOfferBox.offersArray count] == 0)
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
    singleOffer *currentOffer = anotherOfferBox.offersArray[indexPath.row];
    
    cell.nameLabel.text = currentOffer.name;
	cell.updateLabel.text = currentOffer.description;
    cell.commentCountLabel.text = [NSString stringWithFormat:@"$%.2f",[currentOffer.rebate_amount floatValue]];
    
    if ([currentOffer.total_offered intValue] == -1)
        cell.dateLabel.text = [NSString stringWithFormat:@"Unlimited"];
    else {
        if ( ([currentOffer.total_offered intValue] - [currentOffer.num_of_valid_claims intValue] ) < 1 )
            cell.dateLabel.text = @"SOLD OUT";
        else
            cell.dateLabel.text = [NSString stringWithFormat:@"Remaining: %d",([currentOffer.total_offered intValue] - [currentOffer.num_of_valid_claims intValue] )];
    }
    
    //draw check mark on selected cell
    if ( [self.DictionaryOfSelectedOfferIDs objectForKey:((singleOffer *)[anotherOfferBox.offersArray objectAtIndex:indexPath.row]).offerid] )
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.DictionaryOfSelectedOfferIDs objectForKey:((singleOffer *)[anotherOfferBox.offersArray objectAtIndex:indexPath.row]).offerid] == nil)
    {
        [self.DictionaryOfSelectedOfferIDs setObject:[NSNull null]  forKey:((singleOffer *)[anotherOfferBox.offersArray objectAtIndex:indexPath.row]).offerid];
        
        NSLog(@"Row %ld checked",(long)indexPath.row);
    }
    else
    {
        [self.DictionaryOfSelectedOfferIDs removeObjectForKey:((singleOffer *)[anotherOfferBox.offersArray objectAtIndex:indexPath.row]).offerid];
        
        NSLog(@"Row %ld unchecked",(long)indexPath.row);
    }
    
    [tableView  reloadData];
}

-(void)requestReceiptID {
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:[PFUser currentUser].email, @"user_email", @"1", @"upload_receipt", nil];
    self.flOperation = [ApplicationDelegate.flUploadEngine postDataToServer:postParams path: WEB_API_FILE];
    
    __weak typeof(self) weakSelf = self;
    [self.flOperation addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"Requesting receiptID success!");
        //handle a successful 200 response
        NSDictionary *responseDict = [operation responseJSON];
        weakSelf.currentReceiptID = [responseDict objectForKey:@"new receipt"];
    }
    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         NSLog(@"%@", error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to request a new receipt ID, please click upload to try again." delegate:weakSelf cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
         [alert show];
     }];
    
    [ApplicationDelegate.flUploadEngine enqueueOperation:self.flOperation];
}

-(void)uploadImageBox {
    [self.HUD show:YES];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [PFUser currentUser].email, @"user_email",
                                       self.currentReceiptID, @"receiptID",
                                       [NSString stringWithFormat: @"%lu", (unsigned long)anotherBox.imageArray.count],@"num_of_photos",
                                       nil];
    self.flOperation = [ApplicationDelegate.flUploadEngine postDataToServer:postParams path: WEB_API_FILE];
    
    NSLog(@"imagebox has %lu images",(unsigned long)anotherBox.imageArray.count);

    NSInteger counter = 1;
    for (NSData *image in anotherBox.imageArray) {
        NSString *fileName = [NSString stringWithFormat:@"Receipt-%ld.jpeg",(long)counter];
        
        [self.flOperation addData:image forKey:@"file[]" mimeType:@"image/jpeg" fileName:fileName];
        counter++;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.flOperation addCompletionHandler:^(MKNetworkOperation *operation){
        //handle a successful 200 response
        NSLog(@"Images uploaded!");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Upload completed!" delegate:weakSelf cancelButtonTitle:@"Done" otherButtonTitles:nil];
        [alert show];
        [weakSelf.HUD hide:YES];
    }
                              errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                                  NSLog(@"%@", error);
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Upload failed, please try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                                  [alert show];
                                  [weakSelf.HUD hide:YES];
                              }];
    
    [self.flOperation onUploadProgressChanged:^(double progress) {
        self.HUD.progress = progress;
    }];
    
    [ApplicationDelegate.flUploadEngine enqueueOperation:self.flOperation];
}

-(void)addTo_receipts_and_offers_table {
    for (NSNumber* key in self.DictionaryOfSelectedOfferIDs) {
        NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:[key stringValue], @"offerID", self.currentReceiptID, @"receiptID", nil];
        self.flOperation = [ApplicationDelegate.flUploadEngine postDataToServer:postParams path:WEB_API_FILE];
        
        [self.flOperation addCompletionHandler:^(MKNetworkOperation *operation){
            //handle a successful 200 response
        }
                                  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                                      NSLog(@"%@", error);
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                                      [alert show];
                                  }];
        
        
        [ApplicationDelegate.flUploadEngine enqueueOperation:self.flOperation];
    }
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    [self uploadImageBox];
    
    [self addTo_receipts_and_offers_table];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	if([title isEqualToString:@"Done"])
	{
        //clear the imagebox
        [anotherBox emptyBox];
        
        //increment the user account number of receipts
        NSLog(@"User Account number of receipts in process incremented");
        [[PFUser currentUser] incrementKey:@"numberOfReceiptsInProcess"];
        [[PFUser currentUser] saveInBackground];
        
		[self performSegueWithIdentifier:@"Done Uploading" sender:self];
	} else if ([title isEqualToString:@"Dismiss"]) {
        [self performSegueWithIdentifier:@"Back to PicturesView" sender:self];
    } else if ([title isEqualToString:@"Retry"]) {
        [self requestReceiptID];
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

@end
