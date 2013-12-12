//
//  MockFetchIngManager.h
//  Save21
//
//  Created by Leon Chen on 2013-12-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchingManagerCommunicatorDelegate.h"

@interface MockCommunicatorDelegate : NSObject <FetchingManagerCommunicatorDelegate> {
    NSInteger hashFailedErrorCode;
    NSInteger offersListFailedErrorCode;
    NSInteger downloadFailedErrorCode;
    NSInteger requestReceiptIDFailedErrorCode;
    NSInteger uploadFailedErrorCode;
    NSInteger addToTableFailedErrorCode;
    NSInteger userRegFailedErrorCode;
    NSInteger getUserInfoFailedErrorCode;
    
    NSString *receivedHashString;
    NSDictionary *receivedResponseDict;
    NSString *receivedReceipt;
    NSDictionary *receivedUserInfo;
    
    BOOL downloadSuccess;
    BOOL uploadSuccess;
    BOOL receivedFileTransferProgress;
    BOOL addToTableSuccess;
    BOOL userRegistrationWasSuccess;
    BOOL receivedUserInfoWasSuccess;
}

-(NSInteger)hashFailedErrorCode;
-(NSInteger)offersListFailedErrorCode;
-(NSInteger)downloadFailedErrorCode;
-(NSInteger)uploadFailedErrorCode;
-(NSInteger)addToTableFailedErrorCode;
-(NSInteger)userRegFailedErrorCode;
-(NSInteger)requestReceiptIDFailedErrorCode;
-(NSInteger)getUserInfoFailedErrorCode;

-(NSString *)receivedHashString;
-(NSDictionary *)receivedResponseDict;
-(NSString *)receivedReceipt;
-(NSDictionary *)receivedUserInfo;

-(BOOL) downloadSuccess;
-(BOOL) uploadSuccess;
-(BOOL) receivedFileTransferProgress;
-(BOOL) addToTableSuccess;
-(BOOL) userRegistrationWasSuccess;
-(BOOL) receivedUserInfoWasSuccess;
@end
