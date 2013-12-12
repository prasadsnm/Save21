//
//  MockFetchingManagerCommunicator.m
//  Save21
//
//  Created by Leon Chen on 2013-12-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "MockFetchingManagerCommunicator.h"

@implementation MockFetchingManagerCommunicator {
    BOOL wasAskedToFetchOffersHash;
    BOOL wasAskedToFetchOffers;
    BOOL wasAskedToDownloadAFile;
    BOOL wasAskedToUploadImage;
    BOOL wasAskedToAddToReceiptTable;
    BOOL wasAskedToRegisterNewUser;
}

- (BOOL)wasAskedToFetchOffersHash {
    return wasAskedToFetchOffersHash;
}

- (BOOL)wasAskedToFetchOffers {
    return wasAskedToFetchOffers;
}

- (BOOL)wasAskedToDownloadAFile {
    return wasAskedToDownloadAFile;
}

- (BOOL)wasAskedToUploadImage {
    return wasAskedToUploadImage;
}

- (BOOL)wasAskedToAddToReceiptTable {
    return wasAskedToAddToReceiptTable;
}

- (BOOL)wasAskedToRegisterNewUser {
    return wasAskedToRegisterNewUser;
}

-(void)getLastestOffersListHash {
    wasAskedToFetchOffersHash = YES;
    
    [self.delegate receivedOffersListHashString:@"12345"];
    [self.delegate fetchingLatestOffersListHashFailedWithError:[NSError errorWithDomain:@"Mock Error" code:123 userInfo:nil]];
}

-(void)getLastestOffersList {
    wasAskedToFetchOffers = YES;
    
    [self.delegate receivedOffersListResponseDict:[NSDictionary dictionaryWithObjectsAndKeys:@"offerKey",@"offerName", nil]];
    [self.delegate fetchingLastestOffersFailedWithError:[NSError errorWithDomain:@"Mock Error" code:123 userInfo:nil]];
}

-(void)requestToDownloadFileFrom:(NSString*)remoteURL toFile:(NSString*) filePath {
    wasAskedToDownloadAFile = YES;
    
    [self.delegate downloadFileSuccess:remoteURL];
    [self.delegate downloadFileFailedWithError:[NSError errorWithDomain:@"Mock Error" code:123 userInfo:nil] file:remoteURL];
}

-(void)requestReceiptIDForUserEmail:(NSString *)email {
    wasAskedToRegisterNewUser = YES;
    
    [self.delegate receivedReceiptID:@"12345"];
    [self.delegate requestingReceiptIDFailedWithError:[NSError errorWithDomain:@"Mock Error" code:123 userInfo:nil]];
}

-(void)uploadImages:(NSArray *)imagesToUpload forEmail:(NSString *)email andReceiptID:(NSString *)receiptID {
    wasAskedToUploadImage = YES;
    
    [self.delegate uploadImagesSuccess];
    [self.delegate uploadImagesFailedWithError:[NSError errorWithDomain:@"Mock Error" code:123 userInfo:nil]];
}

-(void)addTo_receipts_and_offers_table:(NSString *)receiptID withOfferIDs:(NSMutableDictionary *)offerIDs {
    wasAskedToAddToReceiptTable = YES;
    
    [self.delegate addTo_receipts_and_offers_tableSuccess];
    [self.delegate addTo_receipts_and_offers_tableFailedWithError:[NSError errorWithDomain:@"Mock Error" code:123 userInfo:nil]];
}

-(void)registerUser:(NSString *)userEmail {
    wasAskedToRegisterNewUser = YES;
    
    [self.delegate userRegistrationSuccess];
    [self.delegate userRegistrationFailedWithError:[NSError errorWithDomain:@"Mock Error" code:123 userInfo:nil]];
}

@end
