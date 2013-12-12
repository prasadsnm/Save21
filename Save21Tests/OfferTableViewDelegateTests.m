//
//  OfferTableViewDelegateTests.m
//  Save21
//
//  Created by Leon Chen on 12/10/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OfferTableViewDataSource.h"
#import "singleOffer.h"

@interface OfferTableViewDelegateTests : XCTestCase {
    NSNotification *receivedNotification;
    OfferTableViewDataSource *dataSource;
    singleOffer *testOffer;
}

@end

@implementation OfferTableViewDelegateTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    dataSource = [[OfferTableViewDataSource alloc] init];
    testOffer = [[singleOffer alloc] init];
    testOffer.name = @"Test Offer";
    testOffer.description = @"Test Description";
    [dataSource setOffers:[NSArray arrayWithObject:testOffer]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidReceiveNotification:) name:OfferTableDidSelectOfferNotification object:nil];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    receivedNotification = nil;
    dataSource = nil;
    testOffer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super tearDown];
}

-(void)DidReceiveNotification: (NSNotification *)note {
    receivedNotification = note;
}

-(void)testDelegatePostsNotificationOnSelectionShowWhichOfferWasSelected {
    NSIndexPath *selection = [NSIndexPath indexPathForRow:0 inSection:0];
    [dataSource tableView:nil didSelectRowAtIndexPath:selection];
    XCTAssertEqualObjects([receivedNotification name], @"OfferTableDidSelectOfferNotification", @"The notification message should have the proper given name.");
    XCTAssertEqualObjects([receivedNotification object], testOffer, @"The notification message should carry the offer was selected.");
}


@end
