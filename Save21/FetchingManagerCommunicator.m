//
//  fileUploadEngine.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-14.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

//TESTED

#import "FetchingManagerCommunicator.h"
#import "keysAndUrls.h"

@interface FetchingManagerCommunicator ()

@end

@implementation FetchingManagerCommunicator
@synthesize receivedDictData = _receivedDictData;
@synthesize delegate = _delegate;

-(MKNetworkOperation *)postDataToServer:(NSMutableDictionary *)params path:(NSString *)path {
    apiParameters = params;
    webAPIURL = path;
    
    MKNetworkOperation *op = [self operationWithPath:path params:params httpMethod:@"POST" ssl:NO];
    return op;
}

-(MKNetworkOperation*) downloadFileFrom:(NSString*) remoteURL toFile:(NSString*) filePath {
    fileToDownloadURL = remoteURL;
    filePathToDownloadTo = filePath;
    
    fileToDownloadURL = [fileToDownloadURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    filePathToDownloadTo = [filePathToDownloadTo stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    MKNetworkOperation *op = [self operationWithURLString:remoteURL];
    
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath
                                                            append:NO]];
    
    [self enqueueOperation:op];
    
    return op;
}

- (void)cancelAndDiscardURLConnection {
    [networkOperation cancel];
    networkOperation = nil;
}

-(void)dealloc {
    [networkOperation cancel];
}

#pragma mark - To its delegate

-(void)getLastestOffersListHash{
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"request_offers_hash", nil];
    networkOperation = [self postDataToServer:postParams path: WEB_API_FILE];
    
    __weak typeof(self) weakSelf = self;
    [networkOperation addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"Requesting offer list hash success!");
        //handle a successful 200 response
        weakSelf.receivedDictData = [operation responseJSON];
        NSLog(@"Requested current offer list hash: %@",[weakSelf.receivedDictData objectForKey:@"batch_ID"]);
        NSLog(@"%@",[weakSelf.delegate description]);
        
        [weakSelf.delegate receivedOffersListHashString: [weakSelf.receivedDictData objectForKey:@"batch_ID"]];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"Requesting offer list hash failed!");
        
        weakSelf.receivedDictData = nil;
        
        [weakSelf.delegate fetchingLatestOffersListHashFailedWithError:error];
     }];
    
    [self enqueueOperation:networkOperation];
}

-(void)getLastestOffersList {
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"request_offers", nil];
    networkOperation = [self postDataToServer:postParams path: WEB_API_FILE];
    
    __weak typeof(self) weakSelf = self;
    [networkOperation addCompletionHandler:^(MKNetworkOperation *operation)
     {
         NSLog(@"Offer List request success!");
         //handle a successful 200 response
         weakSelf.receivedDictData = [operation responseJSON];
         
         [weakSelf.delegate receivedOffersListResponseDict:weakSelf.receivedDictData];
         
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
         NSLog(@"Requesting offer list failed!");
         weakSelf.receivedDictData = nil;
         [weakSelf.delegate fetchingLastestOffersFailedWithError:error];
     }];
    [self enqueueOperation:networkOperation];
}

-(void)requestToDownloadFileFrom:(NSString*)remoteURL toFile:(NSString*)filePath{
    NSParameterAssert(remoteURL.length != 0);
    NSParameterAssert(filePath.length != 0);
    
    networkOperation = [self downloadFileFrom:remoteURL toFile:filePath];
    
    __weak typeof(self) weakSelf = self;
    [networkOperation addCompletionHandler:^(MKNetworkOperation* completedRequest) {
        NSLog(@"File %@ downloaded to %@",remoteURL, filePath);
        [weakSelf.delegate downloadFileSuccess:remoteURL];
    }
    errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        NSLog(@"Can't download file: %@",remoteURL);
        [weakSelf.delegate downloadFileFailedWithError:error file:remoteURL];
    }];
    
    [networkOperation onUploadProgressChanged:^(double progress) {
        [self.delegate fileTransferOperationProgress:progress];
    }];
    
}

-(void)requestReceiptIDForUserEmail:(NSString *)email {
    NSParameterAssert(email.length != 0);
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:email, @"user_email", @"1", @"upload_receipt", nil];
    networkOperation = [self postDataToServer:postParams path: WEB_API_FILE];
    
    __weak typeof(self) weakSelf = self;
    [networkOperation addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"Requesting receiptID success!");
        //handle a successful 200 response
        NSDictionary *responseDict = [operation responseJSON];
        NSString *receiptID = [responseDict objectForKey:@"new receipt"];
        
        [weakSelf.delegate receivedReceiptID:receiptID];
    }
    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         NSLog(@"Failed to request a new receipt ID");
         [weakSelf.delegate requestingReceiptIDFailedWithError:error];
     }];
    
    [self enqueueOperation:networkOperation];
}

-(void)uploadImages:(NSArray *)imagesToUpload forEmail:(NSString *)email andReceiptID:(NSString *)receiptID{
    NSLog(@"receiptId: %@, email: %@",receiptID, email);
    NSParameterAssert(imagesToUpload.count != 0);
    NSParameterAssert(email.length != 0);
    NSParameterAssert(receiptID != nil);
    
    filesToUpload = imagesToUpload;
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       email, @"user_email",
                                       receiptID, @"receiptID",
                                       [NSString stringWithFormat: @"%lu", (unsigned long)imagesToUpload.count],@"num_of_photos",
                                       nil];
    networkOperation = [self postDataToServer:postParams path:WEB_API_FILE];
    
    NSLog(@"%lu images to upload.",(unsigned long)imagesToUpload.count);
    
    NSInteger counter = 1;
    for (NSData *image in imagesToUpload) {
        NSString *fileName = [NSString stringWithFormat:@"Receipt-%ld.jpeg",(long)counter];
        
        [networkOperation addData:image forKey:@"file[]" mimeType:@"image/jpeg" fileName:fileName];
        counter++;
    }
    
    __weak typeof(self) weakSelf = self;
    [networkOperation addCompletionHandler:^(MKNetworkOperation *operation){
        //handle a successful 200 response
        NSLog(@"Images uploaded!");
        
        [weakSelf.delegate uploadImagesSuccess];
    }
    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [weakSelf.delegate uploadImagesFailedWithError:error];
    }];
    
    [networkOperation onUploadProgressChanged:^(double progress) {
        [weakSelf.delegate fileTransferOperationProgress:progress];
    }];
    
    [self enqueueOperation:networkOperation];
}

//makes a string in the format of '[ "string1","string2","string3",...]'
-(NSString *)jsonFromMutableArrayOfStrings:(NSMutableArray *)strings {
    if ([strings count]) {
        NSMutableArray *jsonReadyCompanyNames = [[NSMutableArray alloc] init];
        for (NSString *name in strings) {
            [jsonReadyCompanyNames addObject:[NSString stringWithFormat:@"\"%@\"",name]];
        }
        
        NSString *jsonString = @"[";
        
        for (NSString *name in jsonReadyCompanyNames) {
            jsonString = [NSString stringWithFormat:@"%@%@,",jsonString, name];
        }
        
        //remove the last ','
        jsonString = [jsonString substringToIndex:jsonString.length - 1];
        
        jsonString = [jsonString stringByAppendingString:@"]"];
        
        return jsonString;
    }
    return @"[]";
}


-(void)addTo_receipts_and_offers_table:(NSString *)receiptId withOfferIDs:(NSMutableDictionary *)offerIDs {
    NSLog(@"receiptId: %@, offerIDs: %@",receiptId,[offerIDs description]);
    
    NSParameterAssert(receiptId != nil);
    NSParameterAssert([offerIDs count] != 0);
    
    for (NSString* key in offerIDs) {
        NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:key, @"offerID", receiptId, @"receiptID", nil];
        networkOperation = [self postDataToServer:postParams path:WEB_API_FILE];
        
        __weak typeof(self) weakSelf = self;
        [networkOperation addCompletionHandler:^(MKNetworkOperation *operation){
            //handle a successful 200 response
            [weakSelf.delegate addTo_receipts_and_offers_tableSuccess];
        }
        errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"Adding to addTo_receipts_and_offers_table failed");
            [weakSelf.delegate addTo_receipts_and_offers_tableFailedWithError:error];
        }];
        
        [self enqueueOperation:networkOperation];
    }
}

-(void)registerUser:(NSString *)userEmail fName:(NSString *)firstname lName:(NSString *)lastname city:(NSString *)cityname postal:(NSString *)postalCode gender:(NSString *)gender {
    NSParameterAssert(userEmail != nil);
    NSParameterAssert(firstname != nil);
    NSParameterAssert(lastname != nil);
    NSParameterAssert(cityname != nil);
    NSParameterAssert(postalCode != nil);
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"1",@"request_add_user",
                                       userEmail,@"user_email",
                                       firstname,@"first_name",
                                       lastname,@"last_name",
                                       cityname,@"city",
                                       postalCode,@"postal",
                                       gender,@"gender"
                                       ,nil];
    networkOperation = [self postDataToServer:postParams path: WEB_API_FILE];
    
    __weak typeof(self) weakSelf = self;
    [networkOperation addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"New user registration success!");
        //handle a successful 200 response
        NSDictionary *responseDict = [operation responseJSON];
        NSNumber *userid = [responseDict objectForKey:@"new user"];
        NSLog(@"new user's id is %d", [userid intValue]);
        
        [weakSelf.delegate userRegistrationSuccess];
    }
    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
    {
        [weakSelf.delegate userRegistrationFailedWithError:error];
     }];
    
    [self enqueueOperation:networkOperation];
}

-(void)refreshUserInfo:(NSString *)userEmail {
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"request_account_info",
                                       userEmail, @"user_email", nil];
    networkOperation = [self postDataToServer:postParams path: WEB_API_FILE];
    
    __weak typeof(self) weakSelf = self;
    [networkOperation addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"Requesting user account info success!");
        //handle a successful 200 response
        NSDictionary *responseDict = [operation responseJSON];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [responseDict objectForKey:@"num_of_pending_claims"],@"num_of_pending_claims",
                                  [responseDict objectForKey:@"account_balance"],@"account_balance",
                                  [responseDict objectForKey:@"total_savings"],@"total_savings",
                                  [responseDict objectForKey:@"min_amount_redeem_cheque"],@"min_amount_redeem_cheque"
                                  , nil];
        
        [weakSelf.delegate receivedUserInfo:userInfo];
    }
    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
    {
        [weakSelf.delegate receivedUserInfoFailedWithError:error];
        
    }];
    
    [self enqueueOperation:networkOperation];
}

@end