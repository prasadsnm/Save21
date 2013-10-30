//
//  CreateAccountViewController.h
//  Save21
//
//  Created by feiyang chen on 13-10-06.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "fileUploadEngine.h"

@interface CreateAccountViewController : UITableViewController <PFSignUpViewControllerDelegate,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSArray *genderChoices;
@property (strong, nonatomic) NSArray *cityChoices;

@property (nonatomic,strong) fileUploadEngine *flUploadEngine;
@property (nonatomic,strong) MKNetworkOperation *flOperation;

@end
