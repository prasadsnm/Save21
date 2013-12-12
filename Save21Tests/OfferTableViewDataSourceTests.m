//
//  OfferTableViewDataSourceTests.m
//  Save21
//
//  Created by Leon Chen on 2013-12-09.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OfferTableViewDataSource.h"
#import "singleOffer.h"
#import "OfferTableCell.h"

@interface OfferTableViewDataSourceTests : XCTestCase {
    OfferTableViewDataSource *dataSource;
    NSArray *offersList;
}

@end

@implementation OfferTableViewDataSourceTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    dataSource = [[OfferTableViewDataSource alloc] init];
    singleOffer *sampleOffer = [[singleOffer alloc] init];
    sampleOffer.name = @"Test Offer";
    sampleOffer.description = @"Test Offer description";
    sampleOffer.properties = @"Test Offer properties";
    sampleOffer.pictureURL = @"http://test.com/thumbnail.jpg";
    sampleOffer.offerid = @"12345";
    sampleOffer.offerurl = @"http://test.com/offer.html";
    sampleOffer.total_offered = 100;
    sampleOffer.num_of_valid_claims = 10;
    sampleOffer.rebate_amount = 2.5;
    sampleOffer.bannerPictureURL = @"http://test.com/banner.jpg";
    offersList = [NSArray arrayWithObject:sampleOffer];
    [dataSource setOffers:offersList];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    dataSource = nil;
    offersList = nil;
    [super tearDown];
}

-(void)testOneTableRowForOneTopic {
    XCTAssertEqual((NSInteger)[offersList count], [dataSource tableView:nil numberOfRowsInSection:0], @"As there is one offer, there should be one row in the table");
}

-(void)testTwoTableRowsForTwoTopics {
    singleOffer *sampleOffer1 = [[singleOffer alloc] init];
    singleOffer *sampleOffer2 = [[singleOffer alloc] init];
    sampleOffer1.name = @"Test Offer 1";
    sampleOffer1.description = @"Test Offer 1 description";
    sampleOffer1.properties = @"Test Offer 1 properties";
    sampleOffer1.pictureURL = @"http://test.com/thumbnail1.jpg";
    sampleOffer1.offerid = @"12345";
    sampleOffer1.offerurl = @"http://test.com/offer1.html";
    sampleOffer1.total_offered = 100;
    sampleOffer1.num_of_valid_claims = 10;
    sampleOffer1.rebate_amount = 2.5;
    sampleOffer1.bannerPictureURL = @"http://test.com/banner1.jpg";
    
    sampleOffer2.name = @"Test Offer 2";
    sampleOffer2.description = @"Test Offer 2 description";
    sampleOffer2.properties = @"Test Offer 2 properties";
    sampleOffer2.pictureURL = @"http://test.com/thumbnail2.jpg";
    sampleOffer2.offerid = @"12345";
    sampleOffer2.offerurl = @"http://test.com/offer2.html";
    sampleOffer2.total_offered = 100;
    sampleOffer2.num_of_valid_claims = 10;
    sampleOffer2.rebate_amount = 2.5;
    sampleOffer2.bannerPictureURL = @"http://test.com/banner2.jpg";
    
    NSArray *twoOffersList = [NSArray arrayWithObjects:sampleOffer1,sampleOffer2, nil];
    [dataSource setOffers:twoOffersList];
    XCTAssertEqual((NSInteger)[twoOffersList count], [dataSource tableView:nil numberOfRowsInSection:0], @"There should be two rows in the table for two topics");
}

-(void)testOneSectionInTheTableView {
    XCTAssertThrows([dataSource tableView:nil numberOfRowsInSection:1], @"Data source doesn't allow asking about additional section");
}

-(void)testDataSourceCellCreationExpectsOneSection {
    NSIndexPath *secondSection = [NSIndexPath indexPathForItem:0 inSection:1];
    XCTAssertThrows([dataSource tableView:nil cellForRowAtIndexPath:secondSection], @"Data source will not prepare cells for unexpected section");
}

-(void)testDataSourceCellCreationWillNotCreateMoreRowsThanItHasOffers {
    NSIndexPath *afterLastTopic = [NSIndexPath indexPathForRow:[offersList count] inSection: 0];
    XCTAssertThrows([dataSource tableView:nil cellForRowAtIndexPath:afterLastTopic], @"Data source will not prepare more cells than there are topic");
}

@end
