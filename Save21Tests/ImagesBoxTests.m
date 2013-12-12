//
//  ImagesBoxTests.m
//  Save21
//
//  Created by Leon Chen on 12/5/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ImagesBox.h"

@interface ImagesBoxTests : XCTestCase {
    ImagesBox *imageBox;
}

@end

@implementation ImagesBoxTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    imageBox = [ImagesBox imageBox];
}

-(void)testThatImageBoxExists {
    XCTAssertNotNil(imageBox, @"Should be able to create a ImageBox instance");
}

-(void)testTheArrayIsActuallyAnArray {
    XCTAssertTrue([[imageBox imageArray] isKindOfClass: [NSMutableArray class]], @"ImageBox should provide an array");
}

- (void)testAddingAImageDataToTheArray {
    NSData *testDataImage = [NSData data];
    [imageBox addImage:testDataImage];
    [imageBox addImage:testDataImage];
    XCTAssertEqual([[imageBox imageArray] count], (NSUInteger)2, @"Add a image, and the count of image should go up");
}

-(void)testEmptyingTheBoxWorks {
    NSData *testDataImage = [NSData data];
    [imageBox addImage:testDataImage];
    [imageBox emptyBox];
    XCTAssertEqual([[imageBox imageArray] count], (NSUInteger)0, @"Emptied the box, the count of images should be zero");
}

-(void)testCanGetDataOutOfImageBox{
    NSData *testDataImage = [NSData data];
    [imageBox addImage:testDataImage];
    NSData *dataImageFromArray = [[imageBox imageArray] objectAtIndex:0];
    XCTAssertEqualObjects(testDataImage, dataImageFromArray,@"The data from array should be the same one that was put in");
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    imageBox = nil;
    [super tearDown];
}

@end
