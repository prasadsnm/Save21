//
//  UploadViewController.h
//  Crave
//
//  Created by Feiyang Chen on 2013-10-17.
//

#import <UIKit/UIKit.h>
#import "fileUploadEngine.h"
#import <Parse/Parse.h>
#import "MHLazyTableImages.h"

@interface UploadViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MHLazyTableImagesDelegate>

@property (nonatomic,strong) fileUploadEngine *flUploadEngine;
@property (nonatomic,strong) MKNetworkOperation *flOperation;

@end
