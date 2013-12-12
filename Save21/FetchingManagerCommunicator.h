//
//  fileUploadEngine.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-14.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

//TESTED

#import "MKNetworkEngine.h"
#import "FetchingManagerCommunicatorDelegate.h"

@interface FetchingManagerCommunicator : MKNetworkEngine {

@protected
    NSMutableDictionary *apiParameters;
    NSString *webAPIURL;
    
    NSString *fileToDownloadURL;
    NSString *filePathToDownloadTo;
    
    NSArray *filesToUpload;
    
    MKNetworkOperation *networkOperation;
}

@property (nonatomic,strong) NSDictionary *receivedDictData;

@property (strong) id <FetchingManagerCommunicatorDelegate> delegate;

-(void)getLastestOffersListHash;

-(void)getLastestOffersList;

-(void)requestReceiptIDForUserEmail:(NSString *)email;

-(void)uploadImages:(NSArray *)imagesToUpload forEmail:(NSString *)email andReceiptID:(NSString *)receiptID;

-(void)addTo_receipts_and_offers_table:(NSString *)receiptID withOfferIDs:(NSMutableDictionary *)offerIDs;

-(void)registerUser:(NSString *)userEmail fName:(NSString *)firstname lName:(NSString *)lastname
               city:(NSString *)cityname postal:(NSString *)postalCode gender:(NSString *)gender;

-(void)refreshUserInfo:(NSString *)userEmail;

-(void)requestToDownloadFileFrom:(NSString*)remoteURL toFile:(NSString*) filePath;

-(MKNetworkOperation *)postDataToServer:(NSMutableDictionary *)params path:(NSString *)path;

//-(MKNetworkOperation *)downloadFileFrom:(NSString*) remoteURL toFile:(NSString*) filePath;

- (void)cancelAndDiscardURLConnection;

@end