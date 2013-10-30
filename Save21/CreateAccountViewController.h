//
//  CreateAccountViewController.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-06.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
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
