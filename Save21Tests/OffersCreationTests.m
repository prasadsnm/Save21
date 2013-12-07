//
//  OffersCreationTests.m
//  Save21
//
//  Created by Leon Chen on 2013-12-06.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FetchingManager.h"
#import "MockFetchingManagerDelegate.h"
#import "MockFetchingManagerCommunicator.h"

@interface OffersCreationTests : XCTestCase {
    @private
    FetchingManager *manager;
    MockFetchingManagerCommunicator *communicator;
}

@end

@implementation OffersCreationTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    manager = [[FetchingManager alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    manager = nil;
    [super tearDown];
}

- (void)testNonConformingObjectCannotBeDelegate {
    XCTAssertThrows(manager.delegate =
                   (id <FetchingManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate as doesn't" @" conform to the delegate protocol");
}

- (void)testConformingObjectCanBeDelegate {
    id <FetchingManagerDelegate> delegate = [[MockFetchingManagerDelegate alloc] init];
    XCTAssertNoThrow(manager.delegate = delegate,
                    @"Object conforming to the delegate protocol should be used" @" as the delegate");
}

- (void)testManagerAcceptsNilAsADelegate {
    XCTAssertNoThrow(manager.delegate = nil,
                    @"It should be acceptable to use nil as an object’s delegate");
}

- (void)testAskingForOffersMeansRequestingData {
    [manager fetchOffers];
    XCTAssertTrue([communicator wasAskedToFetchOffers], @"The communicator should need to fetch data.");
}

@end
