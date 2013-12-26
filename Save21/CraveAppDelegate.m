//
//  Save21AppDelegate.m
//  Save21
//
//  Created by Feiyang Chen on 10/29/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "CraveAppDelegate.h"
#import <Parse/Parse.h>
#import "keysAndUrls.h"
#import "FetchingManagerCommunicator.h"

@implementation CraveAppDelegate
@synthesize communicator = _communicator;
@synthesize manager = _manager;
@synthesize dataSource = _dataSource;
@synthesize darkColor = _darkColor;
@synthesize boldFontName = _boldFontName;
@synthesize mainColor = _mainColor;
@synthesize textfieldColor = _textfieldColor;
@synthesize sidemenuBackgroundColor = _sidemenuBackgroundColor;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"X1noCMinfG3g7ONkIfnUHhh3yKBbbp7d9YfHJ1D3"
                  clientKey:@"yaciuB3iJEEgc2EYzuAQNLLLuGyG3r3g5pRhSxL6"];
    
    //track the number of opens
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //init the common colors and fonts throughout the app
    self.darkColor = [UIColor colorWithRed:239.0/255 green:55.0/255 blue:52.0/255 alpha:1.0f];
    self.boldFontName = @"Avenir-Black";
    self.mainColor = [UIColor whiteColor];
    self.textfieldColor = [UIColor colorWithRed:255.0/255 green:165.0/255 blue:125.0/255 alpha:1.0f];
    self.sidemenuBackgroundColor = [UIColor colorWithRed:255.0/255 green:88.0/255 blue:85.0/255 alpha:1.0f];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"Avenir-Black" size:21.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setBarTintColor: self.darkColor];
    
    
    self.communicator = [[FetchingManagerCommunicator alloc] initWithHostName:WEBSERVICE_URL customHeaderFields:nil] ;
    self.manager = [[FetchingManager alloc] init] ;
    self.dataSource = [[OfferTableViewDataSource alloc] init] ;
    
    self.communicator.delegate = self.manager;
    
    //gets rid of the status bar on camera overlay screen
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleDefault];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
