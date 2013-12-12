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
#import "keysAndUrls.h"

@interface FetchingManagerTests : XCTestCase {
    @private
    FetchingManager *manager;
    FetchingManager *manager2;
    MockFetchingManagerCommunicator *communicator;
    MockFetchingManagerDelegate *delegate;
    BOOL done;
}

@end

@implementation FetchingManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    manager = [[FetchingManager alloc] init];
    manager2 = [[FetchingManager alloc] init];
    communicator = [[MockFetchingManagerCommunicator alloc] initWithHostName:WEBSERVICE_URL customHeaderFields:nil];
    delegate = [[MockFetchingManagerDelegate alloc] init];
    manager.delegate = delegate;
    manager2.delegate = delegate;
    
    manager.communicator = communicator;
    done = NO;
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

- (void)testAskingForOffersMeansRequestingOffersHash {
    [manager fetchOffers];
    XCTAssertTrue([communicator wasAskedToFetchOffersHash], @"The communicator should need to fetch hash.");
}

- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if([timeoutDate timeIntervalSinceNow] < 0.0)
            break;
    } while (!done);
    
    return done;
}

-(void)testManagerPassesRetrievedOffersListToItsDelegate {
    [manager2 fetchOffers];
    
    //wait 5 secs for the fetching process
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:8];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if([timeoutDate timeIntervalSinceNow] < 0.0)
            break;
    } while (YES);
    
    NSLog(@"delegate.fetchedOffers contains: %@", delegate.fetchedOffers);
    XCTAssertNotNil(delegate.fetchedOffers, @"The delegate should receive offer data from manager.");
    
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    manager = nil;
    communicator = nil;
    manager2 = nil;
    delegate = nil;
    [super tearDown];
}
@end
