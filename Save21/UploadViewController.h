//
//  UploadViewController.h
//  Save21
//
//  Created by Feiyang Chen on 2013-10-17.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fileUploadEngine.h"
#import <Parse/Parse.h>
#import "MHLazyTableImages.h"

@interface UploadViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MHLazyTableImagesDelegate>

@property (nonatomic,strong) fileUploadEngine *flUploadEngine;
@property (nonatomic,strong) MKNetworkOperation *flOperation;

@end
