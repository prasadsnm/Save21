//
//  FetchingManager.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "FetchingManager.h"
#import "OffersArrayBuilder.h"
#import "keysAndUrls.h"

@interface FetchingManager ()

@property (nonatomic,strong) NSString *cachesPath;
@property (nonatomic,strong) NSString *cacheFile;
@property (nonatomic,strong) NSUserDefaults *defaults;

@end

@implementation FetchingManager
@synthesize flOperation = _flOperation;
@synthesize defaults = _defaults;

- (id)init
{
    self = [super init];
    if (self) {
        self.cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        self.cacheFile = [self.cachesPath stringByAppendingPathComponent:@"/offers-cache-file.sav"];
    }
    return self;
}

//get the lastest offer lists hash, so we can see if we already have the lastest list in cache, or need to download the new list
-(void)getLastestOffersListHash {
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"request_offers_hash", nil];
    self.flOperation = [ApplicationDelegate.flUploadEngine postDataToServer:postParams path:WEB_API_FILE];
    
    __weak typeof(self) weakSelf = self;
    [self.flOperation addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"Requesting offer list hash success!");
        //handle a successful 200 response
        NSDictionary *responseDict = [operation responseJSON];
        NSLog(@"Requested current offer list hash: %@",[responseDict objectForKey:@"batch_ID"]);
        weakSelf.currentOffersListHash = [responseDict objectForKey:@"batch_ID"];
        
        [weakSelf checkOfferCache];
    }
    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
    {
         NSLog(@"Requesting offer list hash failed! Read offers from cache instead.");
        //load offers from cache
        //get the responseDict from cache file
        NSDictionary *responseDict = [[NSDictionary alloc] initWithContentsOfFile:weakSelf.cacheFile];
        //send the json file to offer table builder
        [weakSelf receivedOffersJSON:responseDict];
    }];
    
    [ApplicationDelegate.flUploadEngine enqueueOperation:self.flOperation];
}

-(void)downloadOffers {
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"request_offers", nil];
    self.flOperation = [ApplicationDelegate.flUploadEngine postDataToServer:postParams path: WEB_API_FILE];
    
    __weak typeof(self) weakSelf = self;
    [self.flOperation addCompletionHandler:^(MKNetworkOperation *operation)
     {
         NSLog(@"Offer List request success!");
         //handle a successful 200 response
         NSDictionary *responseDict = [operation responseJSON];
         //NSLog(@"%@",[responseDict description]);
         
         //send the json file to offer table builder
         [weakSelf receivedOffersJSON:responseDict];
         
         //save the downloaded json to disk cache and save its hash to UserDefaults
         NSLog(@"Offer list cached to file: %@",weakSelf.cacheFile);
         [responseDict writeToFile:weakSelf.cacheFile atomically:NO];
         [weakSelf.defaults setValue:weakSelf.currentOffersListHash forKey:@"lastestOfferListHash"];
         [weakSelf.defaults synchronize];
         
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
         NSLog(@"%@", error);
         [weakSelf.delegate failedToReceiveOffers];
     }];
    [ApplicationDelegate.flUploadEngine enqueueOperation:self.flOperation];
}

-(void)checkOfferCache {
   NSFileManager *fileManager = [NSFileManager defaultManager];
    //see if defaults contains the hash for the cached file AND the cached file exists
    if ( [self.defaults valueForKey:@"lastestOfferListHash"] && [fileManager fileExistsAtPath:self.cacheFile] ) {
        //check to see if the saved hash is same as the newest from server
        if ( [[self.defaults valueForKey:@"lastestOfferListHash"] isEqualToString: self.currentOffersListHash] ) {
            NSLog(@"The cached offer list is up to date! Proceed by loading from cache.");
            //get the responseDict from cache file
            NSDictionary *responseDict = [[NSDictionary alloc] initWithContentsOfFile:self.cacheFile];
            //send the json file to offer table builder
            [self receivedOffersJSON:responseDict];
        } else {
            NSLog(@"The cached offer list's hash is different from servers! Proceed by downloading from server.");
            [self downloadOffers];
        }
    } else {
        NSLog(@"The cached offers list file doesn't exist or the offers list hash isn't in userdefaults, proceed by downloading from server.");
        
        //download the newest offer list to cache
        [self downloadOffers];
    }
}

-(void)fetchOffers
{
    [self getLastestOffersListHash];
}

#pragma mark - FetchingManagerDelegate

-(void)receivedOffersJSON:(NSDictionary *)objectNotation {
    NSArray *offers = [OffersArrayBuilder offersFromJSON:objectNotation];
    NSString *batchID =[OffersArrayBuilder getOffersBatchID:objectNotation];
    
    [self.delegate didReceiveOffers:offers withBatchID:batchID];
}
@end

