//
//  RootViewControllerTests.m
//  Save21
//
//  Created by Leon Chen on 12/9/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RootViewController.h"

@interface RootViewControllerTests : XCTestCase

@end

@implementation RootViewControllerTests {
    RootViewController *viewController;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    viewController = [[RootViewController alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    viewController = nil;
    [super tearDown];
}


@end
