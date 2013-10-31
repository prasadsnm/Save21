//
//  PicturesViewController.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-16.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "PicturesViewController.h"
#import "PhotoCell.h"
#import "ImagesBox.h"
#import "KGModal.h"

@interface PicturesViewController () {
    ImagesBox *imageBox;
}

@property (strong,nonatomic) UIImagePickerController *imagePicker;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@end

@implementation PicturesViewController
@synthesize imagePicker = _imagePicker;
@synthesize collectionView = _collectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    //Initialize the Singleton imagebox variable
    imageBox = [ImagesBox imageBox];
    
    //UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:7.0/255 green:61.0/255 blue:48.0/255 alpha:1.0f];
    
    NSString* boldFontName = @"Avenir-Black";
    
    self.cancelButton.backgroundColor = darkColor;
    self.cancelButton.layer.cornerRadius = 3.0f;
    self.cancelButton.titleLabel.font = [UIFont fontWithName:boldFontName size:14.0f];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.uploadButton.backgroundColor = darkColor;
    self.uploadButton.layer.cornerRadius = 3.0f;
    self.uploadButton.titleLabel.font = [UIFont fontWithName:boldFontName size:14.0f];
    [self.uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.uploadButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];

    
    self.titleLabel.textColor =  [UIColor whiteColor];
    self.titleLabel.font =  [UIFont fontWithName:boldFontName size:24.0f];
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    //make sure camera is available
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This device doesn't have camera. Can only upload via photo library." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    [self showWelcomeMessage];
}

-(void)showWelcomeMessage {
    //show welcome message using KGModal
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 150)];
    
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"Take Picture";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(welcomeLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect);
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoLabelRect];
    infoLabel.text = @"Click the camera button on the bottom to start taking pictures of your receipts that you wish to upload.";
    infoLabel.numberOfLines = 4;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.shadowColor = [UIColor blackColor];
    infoLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:infoLabel];
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	if([title isEqualToString:@"Ok"])
	{
        //if no camera is found, only let user choose from photo library
	}
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageBox.imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    NSData *image = imageBox.imageArray[indexPath.row];
    cell.image = [UIImage imageWithData:image];
    
    cell.backgroundColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    
    return cell;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}


- (IBAction)cancelButtonPressed {
    //clear the imagebox
    [imageBox emptyBox];
    
    [self performSegueWithIdentifier:@"backToOffer" sender:self];
}

- (IBAction)cameraButtonPressed {
    if (self.imagePicker == nil) {
        self.imagePicker = [[UIImagePickerController alloc] init];
    }
    // If our device has a camera, we want to take a picture, otherwise, we
    // just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.imagePicker setDelegate:self];
        self.imagePicker.cameraFlashMode =UIImagePickerControllerCameraFlashModeOff;
        self.imagePicker.allowsEditing = NO;
        
        [self presentViewController:self.imagePicker animated:YES completion:^{
            //code
        }];
        
    } else {
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        [self.imagePicker setDelegate:self];
        self.imagePicker.allowsEditing = NO;
        [self presentViewController:self.imagePicker animated:YES completion:^{
            //code
        }];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        ////FROM http://stackoverflow.com/a/613576/2876674 ////////////////
        float actualHeight = image.size.height;
        float actualWidth = image.size.width;
        float imgRatio = actualWidth/actualHeight;
        float maxRatio = 320.0/480.0;
        
        if(imgRatio!=maxRatio){
            if(imgRatio < maxRatio){
                imgRatio = 480.0 / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = 480.0;
            }
            else{
                imgRatio = 320.0 / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = 320.0;
            }
        }
        CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:rect];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        ////////////////////////////////////////////////////////////////////
        
        NSData *imageData = UIImageJPEGRepresentation(img, 0.7);
        
        //add the image to singleton imagebox
        [imageBox addImage:imageData];
        
        [self.collectionView reloadData];
        
        NSLog(@"New image added to image array.");
    }];
}

- (IBAction)uploadButtonPressed:(UIButton *)sender {
    //make sure there are at least 1 image before going to upload screen
    if (imageBox.imageArray.count) {
        [self performSegueWithIdentifier:@"Ready to Upload" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No receipts to upload!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
