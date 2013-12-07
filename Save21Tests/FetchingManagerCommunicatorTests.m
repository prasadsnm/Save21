//
//  FetchingManagerCommunicatorTests.m
//  Save21
//
//  Created by Leon Chen on 2013-12-06.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FetchingManagerCommunicator.h"

@interface FetchingManagerCommunicatorTests : XCTestCase {
    FetchingManagerCommunicator *communicator;
    MKNetworkOperation *testNetworkOperation;
    MKNetworkOperation *testNetworkOperation2;
    NSString *testHostName;
    NSMutableDictionary *testParameters;
    NSString *testWebAPIPage;
    NSString *testFilePath;
}

@end

@implementation FetchingManagerCommunicatorTests

- (void)setUp
{
    [super setUp];
    testHostName = @"http://test.com";
    testParameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"testValue", @"testKey", nil];
    testWebAPIPage = @"uploadToMe.php";
    testFilePath = @"downloaded.file";
    communicator = [[FetchingManagerCommunicator alloc] initWithHostName:testHostName customHeaderFields:nil];
    // Put setup code here; it will be run once, before the first test case.
}

-(void)testsThatCommunicatorEngineCanBeCreated {
    XCTAssertTrue(communicator, @"FetchingManagerCommunicator instance exists");
}

-(void)testThatAMKNetworkOperationThatPostDataToServerCanBeCreated {
    testNetworkOperation = [communicator postDataToServer:testParameters path:testWebAPIPage];
    XCTAssertTrue(testNetworkOperation, @"testNetworkOperation instance exists");
}

-(void)testThatAMKNetworkOperationThatDownloadsToFileCanBeCreated {
    testNetworkOperation2 = [communicator downloadFileFrom:testHostName toFile:testFilePath];
    XCTAssertTrue(testNetworkOperation2, @"testNetworkOperation2 instance exists");
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    communicator = nil;
    testNetworkOperation = nil;
    [super tearDown];
}

@end
