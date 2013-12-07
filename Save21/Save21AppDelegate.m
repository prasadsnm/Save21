//
//  Save21AppDelegate.m
//  Save21
//
//  Created by Feiyang Chen on 10/29/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "Save21AppDelegate.h"
#import <Parse/Parse.h>
#import "keysAndUrls.h"
#import "FetchingManagerCommunicator.h"

@implementation Save21AppDelegate
@synthesize communicator = _communicator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"lnyR8Tej9yLqrWO4xZzNHErknO1xkPTaADmTR5ZN"
                  clientKey:@"dPkCTIuS0KAkxjvvvoERaRyYzQPUAhj3a9UDdLBJ"];
    
    //track the number of opens
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    UIColor* darkColor = [UIColor colorWithRed:7.0/255 green:61.0/255 blue:48.0/255 alpha:1.0f];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           darkColor, NSForegroundColorAttributeName,[UIFont fontWithName:@"Avenir-Black" size:21.0], NSFontAttributeName, nil]];
    
    self.communicator = [[FetchingManagerCommunicator alloc] initWithHostName:WEBSERVICE_URL customHeaderFields:nil];
    
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
