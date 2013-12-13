//
//  OffersListTests.m
//  Save21
//
//  Created by Leon Chen on 12/6/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OffersList.h"

@interface OffersListTests : XCTestCase {
    OffersList *offerList;
}

@end

@implementation OffersListTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    offerList = [OffersList offersList];
}

-(void)testThatOffersListExists {
    XCTAssertNotNil(offerList, @"Should be able to create a OffersList instance");
}

-(void)testTheArrayIsActuallyAnArray {
    XCTAssertTrue([offerList.offersArray isKindOfClass: [NSArray class]], @"OffersList should provide an array");
}

-(void)testCanInitWithAnNilWithoutCrashing {
    XCTAssertNoThrow([offerList initializeOffersList:nil], @"OffersList should be able to accept a nil as input array without crashing.");
}

-(void)testCanInitWithAnActualArrayWithoutCrashing {
    NSArray *testArray = [[NSArray alloc] initWithObjects:@"1", @"2", nil];
    XCTAssertNoThrow([offerList initializeOffersList:testArray], @"OffersList should be able to accept a input array without crashing.");
}

-(void)testCanInitWithAnArrayAndAbleToReadTheArray {
    NSArray *testArray = [[NSArray alloc] initWithObjects:@"1", @"2", nil];
    [offerList initializeOffersList:testArray];
    XCTAssertEqualObjects([[offerList offersArray] objectAtIndex: 0], @"1", @"List first item should contain the string '1'");
    XCTAssertEqualObjects([[offerList offersArray] objectAtIndex: 1], @"2", @"List second item should contain the string '2'");
}

-(void)testAfterEmptyingBoxTheArrayIsEmpty {
    [offerList emptyBox];
    XCTAssertEqual([[offerList offersArray] count], (NSUInteger)0, @"The offers list should be 0 after emptying.");
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [offerList emptyBox];
    offerList = nil;
    [super tearDown];
}

@end
