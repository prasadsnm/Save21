//
//  UploadViewController.m
//  Crave
//
//  Created by Feiyang Chen on 2013-10-17.
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
    MHLazyTableImages *_lazyImages;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *offersListTable;
@property (strong, nonatomic) NSMutableDictionary *DictionaryOfSelectedOfferIDs;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) NSNumber *currentReceiptID;
@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation UploadViewController

@synthesize offersListTable = _offersListTable;
@synthesize DictionaryOfSelectedOfferIDs = _DictionaryOfSelectedOfferIDs;
@synthesize flOperation = _flOperation;
@synthesize flUploadEngine = _flUploadEngine;
@synthesize currentReceiptID = _currentReceiptID;

-(NSMutableDictionary *)DictionaryOfSelectedOfferIDs {
    if (_DictionaryOfSelectedOfferIDs == nil) _DictionaryOfSelectedOfferIDs = [[NSMutableDictionary alloc] init];
    return _DictionaryOfSelectedOfferIDs;
}

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
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.labelText = @"Please wait";
    self.self.HUD.detailsLabelText = @"Uploading...";
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
    _lazyImages.tableView = self.offersListTable;
    
    anotherBox = [ImagesBox imageBox];
    anotherOfferBox = [OffersList offersList];
    
    self.flUploadEngine = [[fileUploadEngine alloc]initWithHostName:WEBSERVICE_URL customHeaderFields:nil];
    
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
    cell.commentCountLabel.text = [NSString stringWithFormat:@"$%.2f",currentOffer.rebate_amount];
    if (currentOffer.num_left == -1)
        cell.dateLabel.text = [NSString stringWithFormat:@"Unlimited"];
    else
        cell.dateLabel.text = [NSString stringWithFormat:@"Remaining: %d",currentOffer.num_left];
    
	[_lazyImages addLazyImageForCell:cell withIndexPath:indexPath];
    
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
    {
        //UIImageView *checkBox = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbox-pressed.png"]] autorelease];
        //checkBox.frame = CGRectMake(0, 0, 20, 20);
        //selectedCell.accessoryView = checkBox;
        selectedCell.accessoryType=UITableViewCellAccessoryCheckmark;
        [self.DictionaryOfSelectedOfferIDs setObject:[NSNull null]  forKey:((singleOffer *)[anotherOfferBox.offersArray objectAtIndex:indexPath.row]).offerid];
        
        NSLog(@"Row %ld checked",(long)indexPath.row);
    }
    else  if (selectedCell.accessoryType==UITableViewCellAccessoryCheckmark)
    {
        //UIImageView *checkBox = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbox.png"]] autorelease];
        //checkBox.frame = CGRectMake(0, 0, 20, 20);
        //selectedCell.accessoryView = checkBox;
        selectedCell.accessoryType=UITableViewCellAccessoryNone;
        [self.DictionaryOfSelectedOfferIDs removeObjectForKey:((singleOffer *)[anotherOfferBox.offersArray objectAtIndex:indexPath.row]).offerid];
        
        NSLog(@"Row %ld unchecked",(long)indexPath.row);
    }
    
    [tableView  reloadData];
}

-(void)requestReceiptID {
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:[PFUser currentUser].email, @"user_email", @"1", @"upload_receipt", nil];
    self.flOperation = [self.flUploadEngine postDataToServer:postParams path:@"/indexAPI.php"];
    
    __weak typeof(self) weakSelf = self;
    [self.flOperation addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"Requesting receiptID success!");
        //handle a successful 200 response
        NSDictionary *responseDict = [operation responseJSON];
        weakSelf.currentReceiptID = [responseDict objectForKey:@"new receipt"];
    
        if (weakSelf.currentReceiptID == 0) {
            //got a bad currentReceiptID
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to request a new receipt ID, please click upload to try again." delegate:weakSelf cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Retry", nil];
            [alert show];
        } else {
            NSLog(@"new receiptID is %d", [weakSelf.currentReceiptID intValue]);
        }
    }
    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         NSLog(@"%@", error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to request a new receipt ID, please click upload to try again." delegate:weakSelf cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
         [alert show];
     }];
    
    [self.flUploadEngine enqueueOperation:self.flOperation];
}

-(void)uploadImageBox {
    [self.HUD show:YES];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [PFUser currentUser].email, @"user_email",
                                       [self.currentReceiptID stringValue], @"receiptID",
                                       [NSString stringWithFormat: @"%d", anotherBox.imageArray.count],@"num_of_photos",
                                       nil];
    self.flOperation = [self.flUploadEngine postDataToServer:postParams path:@"/indexAPI.php"];
    
    NSLog(@"imagebox has %lu images",(unsigned long)anotherBox.imageArray.count);

    NSInteger counter = 1;
    for (NSData *image in anotherBox.imageArray) {
        NSString *fileName = [NSString stringWithFormat:@"Receipt-%d.jpeg",counter];
        
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
    
    [self.flUploadEngine enqueueOperation:self.flOperation];
}

-(void)addTo_receipts_and_offers_table {
    for (NSNumber* key in self.DictionaryOfSelectedOfferIDs) {
        NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:[key stringValue], @"offerID", [self.currentReceiptID stringValue], @"receiptID", nil];
        self.flOperation = [self.flUploadEngine postDataToServer:postParams path:@"/indexAPI.php"];
        
        [self.flOperation addCompletionHandler:^(MKNetworkOperation *operation){
            //handle a successful 200 response
        }
                                  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                                      NSLog(@"%@", error);
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                                      [alert show];
                                  }];
        
        
        [self.flUploadEngine enqueueOperation:self.flOperation];
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
	singleOffer *currentOffer = anotherOfferBox.offersArray[indexPath.row];
    NSLog(@"Grabbing table image: %@",currentOffer.pictureURL);
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

@end
