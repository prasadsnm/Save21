//
//  AccountInfoViewController.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-10.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "fileUploadEngine.h"

@interface AccountInfoViewController : UITableViewController

@property (nonatomic,strong) fileUploadEngine *flUploadEngine;
@property (nonatomic,strong) MKNetworkOperation *flOperation;


@end
