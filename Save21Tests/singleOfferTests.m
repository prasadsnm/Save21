//
//  singleOfferTests.m
//  Save21
//
//  Created by Leon Chen on 12/5/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "singleOffer.h"

@interface singleOfferTests : XCTestCase {
    singleOffer *offer;
}


@end

@implementation singleOfferTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    offer = [[singleOffer alloc] init];
    offer.name = @"Test Offer";
    offer.description = @"Test Offer description";
    offer.properties = @"Test Offer properties";
    offer.pictureURL = @"http://test.com/thumbnail.jpg";
    offer.offerid = @"12345";
    offer.offerurl = @"http://test.com/offer.html";
    offer.total_offered = 100;
    offer.num_of_valid_claims = 10;
    offer.rebate_amount = 2.5;
    offer.bannerPictureURL = @"http://test.com/banner.jpg";
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    offer = nil;
    [super tearDown];
}

-(void)testOfferDetailsCanBeRead {
    XCTAssertEqualObjects(offer.name, @"Test Offer", @"Offer's name can be retrieved.");
    XCTAssertEqualObjects(offer.description, @"Test Offer description", @"Offer's description can be retrieved.");
    XCTAssertEqualObjects(offer.properties, @"Test Offer properties", @"Offer's properties can be retrieved.");
    XCTAssertEqualObjects(offer.pictureURL, @"http://test.com/thumbnail.jpg", @"Offer's picture URL can be retrieved.");
    XCTAssertEqualObjects(offer.offerid, @"12345", @"Offer's ID can be retrieved.");
    XCTAssertEqualObjects(offer.offerurl, @"http://test.com/offer.html", @"Offer's page URL can be retrieved.");
    XCTAssertEqual(offer.total_offered, 100, @"Offer's total limit can be retrieved.");
    XCTAssertEqual(offer.num_of_valid_claims, 10, @"Offer's number of valid claims can be retrieved.");
    XCTAssertEqualWithAccuracy(offer.rebate_amount, 2.5, 0.001, @"Offer's rebate amount can be retrieved.");
    XCTAssertEqualObjects(offer.bannerPictureURL, @"http://test.com/banner.jpg", @"Offer's banner picture URL can be retrieved.");
}


@end
