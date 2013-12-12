//
//  Save21AppDelegateTests.m
//  Save21
//
//  Created by Leon Chen on 2013-12-11.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Save21AppDelegate.h"

@interface Save21AppDelegateTests : XCTestCase {
    Save21AppDelegate *appDelegate;
    BOOL didFinishLaunchingWithOptionsReturn;
    
}

@end

@implementation Save21AppDelegateTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    appDelegate = [[Save21AppDelegate alloc] init];
    didFinishLaunchingWithOptionsReturn = [appDelegate application: nil didFinishLaunchingWithOptions: nil];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    appDelegate = nil;
    [super tearDown];
}

- (void)testAppDidFinishLaunchingReturnsYES {
    XCTAssertTrue(didFinishLaunchingWithOptionsReturn, @"Method should return YES");
}

- (void)testAppDelegateHasCommunicatorEngine {
    XCTAssertTrue(appDelegate.communicator, @"The app should have its communicator engine initialized");
}

@end
