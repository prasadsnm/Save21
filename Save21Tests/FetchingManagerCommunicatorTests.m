//
//  FetchingManagerCommunicatorTests.m
//  Save21
//
//  Created by Leon Chen on 2013-12-06.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InspectableFetchingManagerCommunicator.h"
#import "MockFetchingManagerCommunicator.h"
#import "MockCommunicatorDelegate.h"
#import "keysAndUrls.h"

@interface FetchingManagerCommunicatorTests : XCTestCase {
    InspectableFetchingManagerCommunicator *communicator;
    MockFetchingManagerCommunicator *fakeCommunicator;
    
    MockCommunicatorDelegate *delegate;
    
    NSString *testHostName;
    NSString *testWebAPIPage;
    NSString *testFilePath;
}

@end

@implementation FetchingManagerCommunicatorTests

- (void)setUp
{
    [super setUp];
    testHostName = @"http://test.com";
    communicator = [[InspectableFetchingManagerCommunicator alloc] initWithHostName:testHostName customHeaderFields:nil];
    fakeCommunicator = [[MockFetchingManagerCommunicator alloc] initWithHostName:testHostName customHeaderFields:nil];
    
    delegate = [[MockCommunicatorDelegate alloc] init];
    fakeCommunicator.delegate = delegate;
    
    // Put setup code here; it will be run once, before the first test case.
}

-(void)testsThatCommunicatorEngineCanBeCreated {
    XCTAssertTrue(communicator, @"FetchingManagerCommunicator instance exists");
    XCTAssertTrue(fakeCommunicator, @"FetchingManagerCommunicator instance exists");
}

- (void)testGetOffersHashAPI {
    [communicator getLastestOffersListHash];
    
    NSMutableDictionary *correctPostParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"request_offers_hash", nil];
    NSMutableDictionary *receivedParams = [communicator paramToSendToAPI];
    
    NSString *correctAPIAddress = @"/indexAPI.php";
    NSString *receivedAPIAddress = [communicator APIURLAddress];
    
    XCTAssertTrue([receivedParams isEqualToDictionary:correctPostParams], @"Use the correct parameters API to get the latest offers list hash ID");
    XCTAssertTrue([correctAPIAddress isEqualToString:receivedAPIAddress], @"Use the correct request_offers_hash API URL to get the latest offers list hash ID");
}

-(void)testGetOffersAPI {
    [communicator getLastestOffersList];
    
    NSMutableDictionary *correctPostParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"request_offers", nil];
    NSMutableDictionary *receivedParams = [communicator paramToSendToAPI];
    
    NSString *correctAPIAddress = @"/indexAPI.php";
    NSString *receivedAPIAddress = [communicator APIURLAddress];
    
    XCTAssertTrue([receivedParams isEqualToDictionary:correctPostParams], @"Use the correct parameters API to get the latest offers list hash ID");
    XCTAssertTrue([correctAPIAddress isEqualToString:receivedAPIAddress], @"Use the correct request_offers_hash API URL to get the latest offers list hash ID");
}

-(void)testDownloadFileAPI {
    [communicator requestToDownloadFileFrom:@"http://fake.com/file" toFile:@"file"];
    
    NSString *correctFileURL = @"http://fake.com/file";
    NSString *receivedFileURL = [communicator fileToDownload];
    NSLog(@"receivedFileURL: %@",receivedFileURL);
    
    NSString *correctLocalFilePath = @"file";
    NSString *receivedLocalFilePath = [communicator filePathToDownloadTo];
    NSLog(@"receivedLocalFilePath: %@",receivedLocalFilePath);
    
    XCTAssertTrue([correctFileURL isEqualToString:receivedFileURL], @"Have the correct file  URL");
    XCTAssertTrue([correctLocalFilePath isEqualToString:receivedLocalFilePath], @"Have the correct local file path");
}

-(void)testUploadImagesAPI {
    NSData *testData = [NSData data];
    NSArray *testArray = [NSArray arrayWithObjects:testData,testData, nil];
    
    [communicator uploadImages:testArray forEmail:@"hi@hi.com" andReceiptID:@"12345"];
    
    NSMutableDictionary *correctPostParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              @"hi@hi.com", @"user_email",
                                              @"12345", @"receiptID",
                                              @"2",@"num_of_photos",
                                              nil];
    NSMutableDictionary *receivedParams = [communicator paramToSendToAPI];
    
    NSString *correctAPIAddress = @"/indexAPI.php";
    NSString *receivedAPIAddress = [communicator APIURLAddress];
    
    XCTAssertTrue([receivedParams isEqualToDictionary:correctPostParams], @"Use the correct parameters API to upload files to server");
    XCTAssertTrue([correctAPIAddress isEqualToString:receivedAPIAddress], @"Use the correct API URL");
}

-(void)testRequestReceptIDAPI {
    [communicator requestReceiptIDForUserEmail:@"hi@hi.com"];
    
    NSMutableDictionary *correctPostParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"hi@hi.com", @"user_email", @"1", @"upload_receipt", nil];
    NSMutableDictionary *receivedParams = [communicator paramToSendToAPI];
    
    NSString *correctAPIAddress = @"/indexAPI.php";
    NSString *receivedAPIAddress = [communicator APIURLAddress];
    
    XCTAssertTrue([receivedParams isEqualToDictionary:correctPostParams], @"Use the correct parameters API to request receipt ID from server");
    XCTAssertTrue([correctAPIAddress isEqualToString:receivedAPIAddress], @"Use the correct API URL");
}

-(void)testAddToTableAPI {
    NSMutableDictionary *testOfferIDs = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"key", nil];
    
    [communicator addTo_receipts_and_offers_table:@"12345" withOfferIDs:testOfferIDs];
    
    NSMutableDictionary *correctPostParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"key", @"offerID", @"12345", @"receiptID", nil];
    NSMutableDictionary *receivedParams = [communicator paramToSendToAPI];
    
    NSString *correctAPIAddress = @"/indexAPI.php";
    NSString *receivedAPIAddress = [communicator APIURLAddress];
    
    XCTAssertTrue([receivedParams isEqualToDictionary:correctPostParams], @"Use the correct parameters API to add receiptID and offer ID to server");
    XCTAssertTrue([correctAPIAddress isEqualToString:receivedAPIAddress], @"Use the correct API URL");
}

-(void)testRegisterNewUserAPI {
    [communicator registerUser:@"newguy@server.com" fName:@"new" lName:@"guy" city:@"ny" postal:@"123 qwe" gender:@"1"];
    
    NSMutableDictionary *correctPostParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              @"1",@"request_add_user",
                                              @"newguy@server.com",@"user_email",
                                              @"new",@"first_name",
                                              @"guy",@"last_name",
                                              @"ny",@"city",
                                              @"123 qwe",@"postal",
                                              @"1",@"gender"
                                              ,nil];
    NSMutableDictionary *receivedParams = [communicator paramToSendToAPI];
    
    NSString *correctAPIAddress = @"/indexAPI.php";
    NSString *receivedAPIAddress = [communicator APIURLAddress];
    
    NSLog(@"%@", [receivedParams description]);
    NSLog(@"%@", [correctPostParams description]);
    
    XCTAssertTrue([receivedParams isEqualToDictionary:correctPostParams], @"Use the correct parameters API to add a new user");
    XCTAssertTrue([correctAPIAddress isEqualToString:receivedAPIAddress], @"Use the correct API URL");
}

-(void)testGetAccountInfoAPI {
    [communicator refreshUserInfo:@"newGuy@server.com"];
    
    NSMutableDictionary *correctPostParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"request_account_info",
                                              @"newGuy@server.com", @"user_email", nil];    NSMutableDictionary *receivedParams = [communicator paramToSendToAPI];
    
    NSString *correctAPIAddress = @"/indexAPI.php";
    NSString *receivedAPIAddress = [communicator APIURLAddress];
    
    XCTAssertTrue([receivedParams isEqualToDictionary:correctPostParams], @"Use the correct parameters API to request user info for an user");
    XCTAssertTrue([correctAPIAddress isEqualToString:receivedAPIAddress], @"Use the correct API URL");
}

/*
- (void)testGetOffersHashPassesDataAndErrorToDelegate {
    [fakeCommunicator getLastestOffersListHash];
    XCTAssertTrue([delegate receivedHashString], @"The delegate should have received hash data on success");
    XCTAssertTrue([delegate hashFailedErrorCode], @"The delegate should have received error code on failure");
}

- (void)testGetOffersPassesDataToDelegate {
    [fakeCommunicator getLastestOffersList];
    XCTAssertTrue([delegate receivedResponseDict], @"The delegate should have received offer data on success");
    XCTAssertTrue([delegate offersListFailedErrorCode], @"The delegate should have error code on failure");
}

- (void)testDownloadFilePassesDataToDelegate {
    [fakeCommunicator requestToDownloadFileFrom:@"test" toFile:@"test"];
    
    XCTAssertTrue([delegate downloadSuccess], @"The delegate should have received successful message");
    XCTAssertTrue([delegate downloadFailedErrorCode], @"The delegate should have received error code");
}

- (void)testRequestReceiptIDPassesDataToDelegate {
    [fakeCommunicator requestReceiptIDForUserEmail:@"user@test.com"];
    
    XCTAssertEqualObjects([delegate receivedReceipt], @"12345", @"The delegate should have received a response receipt ID from commuicator;");
    XCTAssertTrue([delegate requestReceiptIDFailedErrorCode], @"The delegate should have received a error code");
}

-(void)testUploadImagesPassesDataToDelegate {
    NSData *testData = [NSData data];
    NSArray *testArray = [NSArray arrayWithObjects:testData,testData, nil];
    
    [fakeCommunicator uploadImages:testArray forEmail:@"not important" andReceiptID:@"123"];
    
    XCTAssertTrue([delegate uploadSuccess], @"The delegate should have received successful message");
    XCTAssertTrue([delegate uploadFailedErrorCode], @"The delegate should have received a error code");
}

-(void)testAddToTablePassesDataToDelegate {
    NSMutableDictionary *testOfferIDs = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNull null],@"key", nil];
    
    [fakeCommunicator addTo_receipts_and_offers_table:@"123" withOfferIDs:testOfferIDs];
    
    XCTAssertTrue([delegate addToTableSuccess], @"The delegate should have received successful message");
    XCTAssertTrue([delegate addToTableFailedErrorCode], @"The delegate should have received a error code");
}

*/

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    communicator = nil;
    fakeCommunicator = nil;
    delegate = nil;
    [super tearDown];
}

@end
