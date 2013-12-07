//
//  OffersArrayBuilderTests.m
//  Save21
//
//  Created by Leon Chen on 12/6/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OffersArrayBuilder.h"
#import "singleOffer.h"

@interface OffersArrayBuilderTests : XCTestCase {
    NSDictionary *offerDetails;
    NSString *batch_ID;
    NSArray *oneOfferJSON;
    NSDictionary *validJSONDictionary;
    NSDictionary *invalidJSONDictionary;
    NSDictionary *badDictionary;
    NSDictionary *noOffersJSONDictionary;
}

@end

@implementation OffersArrayBuilderTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    offerDetails = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"Halloween Shopping Spree",@"name",
                    @"Costumes, Make Up, And Everything To Creep It Real",@"description",
                    @"banner",@"properties",
                    @"Offer-1-Thumbnail.jpg",@"pictureURL",
                    @"8",@"offerid",
                    @"offer-8.webarchive",@"offerurl",
                    @"10",@"total_offered",
                    @"5",@"num_of_valid_claims",
                    @"20.00",@"rebate_amount",
                    @"Offer-1-Banner.jpg",@"bannerPictureURL",
                    nil];
    batch_ID = @"3f76a5c764fa0477416605946dc33510";
    oneOfferJSON = [[NSArray alloc] initWithObjects:offerDetails, nil];
    validJSONDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:oneOfferJSON,@"offers",batch_ID,@"batch_ID", nil];
    invalidJSONDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"true",@"nooffers", nil];
    badDictionary = [[NSDictionary alloc] init];
    noOffersJSONDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:nil,@"offers",batch_ID,@"batch_ID", nil];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.

    [super tearDown];
}

- (void)testThatNilIsNotAnAcceptableParameter {
    XCTAssertThrows([OffersArrayBuilder offersFromJSON:nil error:NULL], @"Lack of data should have been handled elsewhere");
    XCTAssertThrows([OffersArrayBuilder getOffersPageURLs:nil error:NULL], @"Lack of data should have been handled elsewhere");
}

- (void)testNilReturnedWhenDictionaryNotCorrect {
    XCTAssertNil([OffersArrayBuilder offersFromJSON:invalidJSONDictionary error:NULL], @"This parameter should not be parsable");
    XCTAssertNil([OffersArrayBuilder getOffersPageURLs:invalidJSONDictionary error:NULL], @"This parameter should not be parsable");
    XCTAssertNil([OffersArrayBuilder offersFromJSON:badDictionary error:NULL], @"This parameter should not be parsable");
    XCTAssertNil([OffersArrayBuilder getOffersPageURLs:badDictionary error:NULL], @"This parameter should not be parsable");
}

- (void)testErrorSetWhenDictionaryNotCorrect {
    NSError *error = nil;
    NSError *error2 = nil;
    NSError *error3 = nil;
    NSError *error4 = nil;
    [OffersArrayBuilder offersFromJSON:invalidJSONDictionary error:&error];
    [OffersArrayBuilder getOffersPageURLs:invalidJSONDictionary error:&error2];
    [OffersArrayBuilder offersFromJSON:badDictionary error:&error3];
    [OffersArrayBuilder getOffersPageURLs:badDictionary error:&error4];
    XCTAssertNotNil(error, @"An error occurred, we should be told");
    XCTAssertNotNil(error2, @"An error occurred, we should be told");
    XCTAssertNotNil(error3, @"An error occurred, we should be told");
    XCTAssertNotNil(error4, @"An error occurred, we should be told");
}

- (void)testPassingNullErrorDoesNotCauseCrash {
    XCTAssertNoThrow([OffersArrayBuilder offersFromJSON:invalidJSONDictionary error:NULL], @"Using a NULL error parameter should not be a problem");
    XCTAssertNoThrow([OffersArrayBuilder getOffersPageURLs:invalidJSONDictionary error:NULL], @"Using a NULL error parameter should not be a problem");
}

- (void)testRealJSONWithoutOfferDetailsReturnsInvalidJSONError {
    NSError *error = nil;
    [OffersArrayBuilder offersFromJSON:invalidJSONDictionary error:&error];
    NSError *error2 = nil;
    [OffersArrayBuilder getOffersPageURLs:invalidJSONDictionary error:&error2];
    XCTAssertEqual([error code], OffersArrayInvalidJSONError, @"This case should be an invalid JSON error");
    XCTAssertEqual([error2 code], OffersArrayInvalidJSONError, @"This case should be an invalid JSON error");
}

- (void)testJSONWithOneOfferReturnsOneOfferObject {
    NSError *error = nil;
    NSArray *offers = [OffersArrayBuilder offersFromJSON:validJSONDictionary error:&error];
    XCTAssertEqual([offers count], (NSUInteger)1, @"The builder should have created a offer");
}

- (void)testOfferCreatedFromJSONHasPropertiesPresentedInJSON {
    singleOffer *offer = [[OffersArrayBuilder offersFromJSON:validJSONDictionary error:NULL] objectAtIndex: 0];
    
    XCTAssertEqualObjects(offer.name, @"Halloween Shopping Spree", @"Title should match the provided data");
    XCTAssertEqualObjects(offer.description, @"Costumes, Make Up, And Everything To Creep It Real", @"description should match the provided data");
    XCTAssertEqualObjects(offer.properties, @"banner", @"properties should match the provided data");
    XCTAssertEqualObjects(offer.pictureURL, @"Offer-1-Thumbnail.jpg", @"pictureURL should match the provided data");
    XCTAssertEqualObjects(offer.offerid, @"8", @"offerid should match the provided data");
    XCTAssertEqualObjects(offer.offerurl, @"offer-8.webarchive", @"offerurl should match the provided data");
    XCTAssertEqual(offer.total_offered, 10, @"total_offered should match the provided data");
    XCTAssertEqual(offer.num_of_valid_claims, 5, @"num_of_valid_claims should match the provided data");
    XCTAssertEqualWithAccuracy(offer.rebate_amount, 20, 0.001, @"rebate_amount should match the provided data");
    XCTAssertEqualObjects(offer.bannerPictureURL, @"Offer-1-Banner.jpg", @"bannerPictureURL should match the provided data");
}

@end
