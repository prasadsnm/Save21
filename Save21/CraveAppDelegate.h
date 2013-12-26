//
//  Save21AppDelegate.h
//  Save21
//
//  Created by Feiyang Chen on 10/29/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FetchingManagerCommunicator.h"
#import "FetchingManager.h"
#import "OfferTableViewDataSource.h"

#define ApplicationDelegate ((CraveAppDelegate *)[[UIApplication sharedApplication] delegate])

@interface CraveAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FetchingManagerCommunicator *communicator;

@property (strong, nonatomic) FetchingManager *manager;

@property (strong, nonatomic) OfferTableViewDataSource *dataSource;

@property (strong, nonatomic) UIColor* darkColor;
@property (strong, nonatomic) NSString* boldFontName;
@property (strong, nonatomic) UIColor* mainColor;
@property (strong, nonatomic) UIColor* textfieldColor;
@property (strong, nonatomic) UIColor* sidemenuBackgroundColor;

@end
