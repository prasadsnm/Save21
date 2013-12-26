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
#import "CameraOverlay.h"

@interface PicturesViewController () <UIActionSheetDelegate> {
    ImagesBox *imageBox;
}

@property (weak, nonatomic) IBOutlet UIImageView *helpPictureGuide;

@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (strong,nonatomic) CameraOverlay *overlayView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

#define TAKE_PHOTO @"Take Photo"
#define PICK_PHOTO @"Pick from Library"

@end

@implementation PicturesViewController
@synthesize helpPictureGuide = _helpPictureGuide;
@synthesize imagePicker = _imagePicker;
@synthesize overlayView = _overlayView;
@synthesize collectionView = _collectionView;
@synthesize cancelButton = _cancelButton;
@synthesize uploadButton = _uploadButton;
@synthesize actionSheet = _actionSheet;

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
    
    self.cancelButton.backgroundColor = ApplicationDelegate.darkColor;
    self.cancelButton.layer.cornerRadius = 3.0f;
    self.cancelButton.titleLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:14.0f];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.uploadButton.backgroundColor = ApplicationDelegate.darkColor;
    self.uploadButton.layer.cornerRadius = 3.0f;
    self.uploadButton.titleLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:14.0f];
    [self.uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.uploadButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];

    
    self.titleLabel.textColor = ApplicationDelegate.darkColor;
    self.titleLabel.font =  [UIFont fontWithName:ApplicationDelegate.boldFontName size:24.0f];
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Get Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:TAKE_PHOTO,PICK_PHOTO, nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //show or hide the picture guide
    if (imageBox.imageArray.count == 0) {
        [self.helpPictureGuide setHidden:NO];
    } else {
        [self.helpPictureGuide setHidden:YES];
    }
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
    
    cell.backgroundColor = [UIColor whiteColor];
    
    [cell.deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
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
        // If our device has a camera, give the user the options to take a picture or pick from photo library
    //otherwise, just go straight to picking from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //show the action sheet
        [self.actionSheet showInView:self.view];

    } else { //go straight to picking from photo library
        if (self.imagePicker == nil) {
            self.imagePicker = [[UIImagePickerController alloc] init];
        }
        
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        [self.imagePicker setDelegate:self];
        self.imagePicker.allowsEditing = NO;
        [self presentViewController:self.imagePicker animated:YES completion:^{
            //code
        }];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (self.imagePicker == nil) {
        self.imagePicker = [[UIImagePickerController alloc] init];
    }
    
    if ([choice isEqualToString:TAKE_PHOTO]) {
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.imagePicker setDelegate:self];
        
        if (!self.overlayView)
            self.overlayView = [[CameraOverlay alloc] initWithNibName:@"CameraOverlay" bundle:nil];
        
        //create overlayView
        if (IsIphone5) {
            [self.overlayView.overlayImage setImage:[UIImage imageNamed:@"overlay_iphone5.png"]];
        } else {
            [self.overlayView.overlayImage setImage:[UIImage imageNamed:@"overlay_iphone4.png"]];
        }
        
        self.imagePicker.cameraFlashMode =UIImagePickerControllerCameraFlashModeOff;
        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.showsCameraControls = YES;
        self.imagePicker.cameraOverlayView = self.overlayView.view;
        
        [self presentViewController:self.imagePicker animated:YES completion:^{
            //code
        }];
        
    } else if ([choice isEqualToString:PICK_PHOTO]) {
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        [self.imagePicker setDelegate:self];
        self.imagePicker.allowsEditing = NO;
        [self presentViewController:self.imagePicker animated:YES completion:^{
            //code
        }];
    }
}

//the action for the delete button in each PhotoCell
- (void)deleteButtonPressed:(UIButton *)sender
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(PhotoCell *)sender.superview.superview];
    
    [imageBox.imageArray removeObjectAtIndex:indexPath.row];
    
    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    
    if (imageBox.imageArray.count == 0) {
        //show the picture guide
        [self.helpPictureGuide setHidden:NO];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        ////FROM http://stackoverflow.com/a/613576/2876674 ////////////////
        float actualHeight = image.size.height;
        float actualWidth = image.size.width;
        float imgRatio = actualWidth/actualHeight;
        float maxRatio = 640.0/960.0;
        
        if(imgRatio!=maxRatio){
            if(imgRatio < maxRatio){
                imgRatio = 960.0 / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = 960.0;
            }
            else{
                imgRatio = 640.0 / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = 640.0;
            }
        }
        CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:rect];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        ////////////////////////////////////////////////////////////////////
        
        NSData *imageData = UIImageJPEGRepresentation(img, 0.7);
        
        //hide the picture guide
        [self.helpPictureGuide setHidden:YES];
        
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
