//
//  FetchingManagerCommunicatorDelegate.h
//  Save21
//
//  Created by Leon Chen on 2013-12-07.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FetchingManagerCommunicatorDelegate <NSObject>

@optional

//signal from communicator that fetching the lastest offers list hash has failed
-(void)fetchingLatestOffersListHashFailedWithError: (NSError *)error;

//signal that the communicator has received the Offers List hash from server
-(void)receivedOffersListHashString:(NSString *)hashString;

//signal from communicator that fetching the lastest offers has failed
-(void)fetchingLastestOffersFailedWithError: (NSError *)error;

//signal that the communicator has received the Offers List from server
-(void)receivedOffersListResponseDict:(NSDictionary *)responseDict;

//signal from communicator that the file download has failed
-(void)downloadFileFailedWithError: (NSError *)error file:(NSString *)fileName;

//signal that the communicator the file has been downloaded successfully
-(void)downloadFileSuccess:(NSString *)fileName;

//signal from the communicator that requesting a receiptID for a given user email has failed
-(void)requestingReceiptIDFailedWithError: (NSError *)error;

//signal that the communicator has returned with the new receipt ID for this user
-(void)receivedReceiptID:(NSString *)receiptID;

//signal from the communicator that the uploading image process has failed
-(void)uploadImagesFailedWithError: (NSError *)error;

//signal from the communicator that the uploading image process was successful
-(void)uploadImagesSuccess;

//signal from the communicator of the percentage of the current file transfer operation
-(void)fileTransferOperationProgress:(double)percentage;

//signal from the communicator that the receipts_and_offers_table update operation has failed
-(void)addTo_receipts_and_offers_tableFailedWithError: (NSError *)error;

//signal from the communicator that the receipts_and_offers_table update operation was successful
-(void)addTo_receipts_and_offers_tableSuccess;

//signal from the communicator that the registry of new user failed
-(void)userRegistrationFailedWithError:(NSError *)error;

//signal from the communicator that the registry of new user to our server was successful
-(void)userRegistrationSuccess;

//signal from the communicator that user info has been received
-(void)receivedUserInfo:(NSDictionary *)userInfo;

//signal from the communicator failed to get user info
-(void)receivedUserInfoFailedWithError:(NSError *)error;
@end
