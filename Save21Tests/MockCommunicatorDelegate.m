//
//  MockFetchIngManager.m
//  Save21
//
//  Created by Leon Chen on 2013-12-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "MockCommunicatorDelegate.h"

@implementation MockCommunicatorDelegate

-(NSInteger)hashFailedErrorCode{
    return hashFailedErrorCode;
}

-(NSInteger)offersListFailedErrorCode{
    return offersListFailedErrorCode;
}

-(NSInteger)downloadFailedErrorCode{
    return downloadFailedErrorCode;
}

-(NSInteger)uploadFailedErrorCode{
    return uploadFailedErrorCode;
}

-(NSInteger)addToTableFailedErrorCode{
    return addToTableFailedErrorCode;
}

-(NSInteger)userRegFailedErrorCode{
    return userRegFailedErrorCode;
}

-(NSInteger)requestReceiptIDFailedErrorCode{
    return requestReceiptIDFailedErrorCode;
}

-(NSInteger)getUserInfoFailedErrorCode{
    return getUserInfoFailedErrorCode;
}

-(NSString *)receivedHashString {
    return receivedHashString;
}

-(NSDictionary *)receivedResponseDict{
    return receivedResponseDict;
}

-(NSString *)receivedReceipt{
    return receivedReceipt;
}

-(NSDictionary *)receivedUserInfo{
    return receivedUserInfo;
}

-(BOOL) downloadSuccess {
    return downloadSuccess;
}

-(BOOL) uploadSuccess {
    return uploadSuccess;
}

-(BOOL) receivedFileTransferProgress {
    return receivedFileTransferProgress;
}

-(BOOL) addToTableSuccess {
    return addToTableSuccess;
}

-(BOOL) userRegistrationWasSuccess {
    return userRegistrationWasSuccess;
}

-(BOOL) receivedUserInfoWasSuccess {
    return receivedUserInfoWasSuccess;
}

//signal from communicator that fetching the lastest offers list hash has failed
-(void)fetchingLatestOffersListHashFailedWithError: (NSError *)error {
    hashFailedErrorCode = [error code];
}

//signal that the communicator has received the Offers List hash from server
-(void)receivedOffersListHashString:(NSString *)hashString {
    receivedHashString = hashString;
}

//signal from communicator that fetching the lastest offers has failed
-(void)fetchingLastestOffersFailedWithError: (NSError *)error{
    offersListFailedErrorCode = [error code];
}

//signal that the communicator has received the Offers List from server
-(void)receivedOffersListResponseDict:(NSDictionary *)responseDict{
    receivedResponseDict = responseDict;
}

//signal from communicator that the file download has failed
-(void)downloadFileFailedWithError: (NSError *)error file:(NSString *)fileName{
    downloadFailedErrorCode = [error code];
}

//signal that the communicator the file has been downloaded successfully
-(void)downloadFileSuccess:(NSString *)fileName{
    downloadSuccess = YES;
}

//signal from the communicator that requesting a receiptID for a given user email has failed
-(void)requestingReceiptIDFailedWithError: (NSError *)error {
    requestReceiptIDFailedErrorCode = [error code];
}

//signal that the communicator has returned with the new receipt ID for this user
-(void)receivedReceiptID:(NSString *)receiptID {
    receivedReceipt = receiptID;
}

//signal from the communicator that the uploading image process has failed
-(void)uploadImagesFailedWithError: (NSError *)error {
    uploadFailedErrorCode = [error code];
}

//signal from the communicator that the uploading image process was successful
-(void)uploadImagesSuccess {
    uploadSuccess = YES;
}

//signal from the communicator of the percentage of the current file transfer operation
-(void)fileTransferOperationProgress:(double)percentage {
    receivedFileTransferProgress = YES;
}

//signal from the communicator that the receipts_and_offers_table update operation has failed
-(void)addTo_receipts_and_offers_tableFailedWithError: (NSError *)error {
    addToTableFailedErrorCode = [error code];
}

//signal from the communicator that the receipts_and_offers_table update operation was successful
-(void)addTo_receipts_and_offers_tableSuccess {
    addToTableSuccess = YES;
}

//signal from the communicator that the registry of new user failed
-(void)userRegistrationFailedWithError:(NSError *)error {
    userRegFailedErrorCode = [error code];
}

//signal from the communicator that the registry of new user to our server was successful
-(void)userRegistrationSuccess {
    userRegistrationWasSuccess = YES;
}

//signal from the communicator that user info has been received
-(void)receivedUserInfo:(NSDictionary *)userInfo {
    receivedUserInfo = userInfo;
    receivedUserInfoWasSuccess = YES;
}

//signal from the communicator failed to get user info
-(void)receivedUserInfoFailedWithError:(NSError *)error{
    getUserInfoFailedErrorCode = [error code];
}
@end
