//
//  FetchingManager.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "FetchingManager.h"
#import "FetchingManagerCommunicator.h"
#import "OffersArrayBuilder.h"
#import "keysAndUrls.h"

static NSInteger cacheMaxCacheAge = 60*60*24*7; // 1 week

@interface FetchingManager ()

@property (nonatomic,strong) NSString *cachesPath;
@property (nonatomic,strong) NSString *cacheFile;
@property (nonatomic,strong) NSUserDefaults *defaults;
@property (nonatomic,strong) NSString *offerPageCachesPath;
@property (nonatomic,strong) NSString *currentOffersListHash;

@end

@implementation FetchingManager
@synthesize cachesPath = _cachesPath;
@synthesize cacheFile = _cacheFile;
@synthesize offerPageCachesPath = _offerPageCachesPath;
@synthesize delegate = _delegate;
@synthesize defaults = _defaults;
@synthesize communicator = _communicator;

#pragma mark - Its own functions

- (void)setDelegate:(id<FetchingManagerDelegate>)newDelegate {
    if (newDelegate && ![newDelegate conformsToProtocol: @protocol(FetchingManagerDelegate)]) {
        [[NSException exceptionWithName: NSInvalidArgumentException reason:
          @"Delegate object does not conform to the delegate protocol" userInfo: nil] raise];
    }
    _delegate = newDelegate;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        self.cacheFile = [self.cachesPath stringByAppendingPathComponent:@"/offers-cache-file.sav"];
        self.offerPageCachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"offer_page_cache"];
        self.defaults = [NSUserDefaults standardUserDefaults];
        self.communicator = ApplicationDelegate.communicator;
    }
    return self;
}

//start here
-(void)fetchOffers
{
    //for some reason, if this function is called the second time, the communicatorEngine's delegate would become nil.
    //So must set it each time.
    self.communicator.delegate = self;
    
    //first clean the cache of anything over 1 week old
    [self cleanOfferPageCache];
    
    //start by checking the lastest offers list's hash ID, see if need updating
    [self checkLastestOffersListHash];
}

//tell the communicator to fetch the lastest offer lists hash, so we can see if we already have the lastest list in cache, or need to download the new list
-(void)checkLastestOffersListHash {
    
    [self.communicator getLastestOffersListHash];
}

//we need to download the offer list from server
-(void)downloadOffers {
    [self.communicator getLastestOffersList];
}

//check to see if we already have the latest offers cached by looking at the hash ID
//if we do, then no need to download the offers list again, just read from cache
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
        
        [self downloadOffers];
    }
}

//download all offer's display pages
-(void)preloadOfferPageCache:(NSDictionary *)objectNotation {
    NSError *error = nil;
    NSArray *offerPageURLs = [OffersArrayBuilder getOffersPageURLs:objectNotation error:&error];
    
    if (!offerPageURLs) {
        [self tellDelegateAboutOfferFetchError: error];
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *offerPageCachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"offer_page_cache"];
    NSLog(@"List of URLs to download: %@", offerPageURLs);
    
    if (![fileManager fileExistsAtPath:offerPageCachePath])
    {
        NSError* error = nil;
        NSLog(@"Creating directory: %@", offerPageCachePath);
        if (![fileManager createDirectoryAtPath:offerPageCachePath withIntermediateDirectories:YES attributes:nil error:&error])
            NSLog(@"Error creating directory: %@", [error description]);
    }
    
    for (NSString *offerPageURL in offerPageURLs) {
        NSString *offerPageCacheFile = [offerPageCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",offerPageURL]];
        NSLog(@"Trying to locate web page from cache: %@",offerPageURL);
        
        //Check to see if the file exists at the location
        if ([[NSFileManager defaultManager] fileExistsAtPath:offerPageCacheFile]) {
            NSLog(@"Found web page in cache! Skipping download");
        }
        else
        {
            NSLog(@"Need to download %@", offerPageCacheFile);
            [self downloadWebPage:offerPageURL toFile:offerPageCacheFile];
        }

    }

}

//download a offer page to cache
-(void)downloadWebPage:(NSString *)offerPageURL toFile:(NSString *)offerPageCachePath {
    [self.communicator requestToDownloadFileFrom:[NSString stringWithFormat:@"%@%@",OFFER_PAGES_URL, offerPageURL] toFile:offerPageCachePath];
}

//clear any expired offer pages cache
- (void)cleanOfferPageCache
{
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-cacheMaxCacheAge];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:self.offerPageCachesPath];
    NSLog(@"Checking for expired offer page cache...");
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [self.offerPageCachesPath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
        {
            NSLog(@"Deleted %@ cache file, over one week old",filePath);
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}

#pragma mark - From FetchingManagerCommunicatorDelegate

-(void)receivedOffersListHashString:(NSString *)hashString {
    self.currentOffersListHash = hashString;
    
    //if we already have the latest offers cached
    [self checkOfferCache];
}

//this happens if the user is not connected to internet
-(void)fetchingLatestOffersListHashFailedWithError:(NSError *)error {
    NSLog(@"Requesting offer list hash failed! Read offers from cache instead.");
    
    //Read offers from cache
    NSDictionary *responseDict = [[NSDictionary alloc] initWithContentsOfFile:self.cacheFile];
    
    //send the json file to offer table builder
    [self receivedOffersJSON:responseDict];
    
}

-(void)receivedOffersListResponseDict:(NSDictionary *)responseDict {
    //send the offer JSON file to offer table builder
    [self receivedOffersJSON:responseDict];
}

//this happens only if the internet cut off immediately after successfully
//fetching the new offers hash ID from server and needs to update offers list
-(void)fetchingLastestOffersFailedWithError:(NSError *)error {
    NSLog(@"Requesting offer list failed!");
    NSError *reportError = [NSError errorWithDomain:FetchingManagerError code: FetchingManagerErrorOffersFetchCode userInfo:nil];
    [self.delegate failedToReceiveOffersWithError:reportError];
}

-(void)downloadFileSuccess:(NSString *)fileName {
    NSLog(@"Offer page %@ downloaded",fileName);
}

-(void)downloadFileFailedWithError:(NSError *)error file:(NSString *)fileName {
    NSLog(@"Offer page %@ failed to download",fileName);
}

#pragma mark - To its delegate
//send the offers to its delegate
-(void)receivedOffersJSON:(NSDictionary *)objectNotation {
    NSError *error = nil;
    NSArray *offers = [OffersArrayBuilder offersFromJSON:objectNotation error:&error];
    //no offers exist in the JSON file
    if (!offers) {
        [self tellDelegateAboutOfferFetchError: error];
        return;
    }
    
    //save the downloaded json to disk cache and save its hash to UserDefaults
    NSLog(@"Offer list cached to file: %@",self.cacheFile);
    [objectNotation writeToFile:self.cacheFile atomically:NO];
    
    [self.defaults setValue:self.currentOffersListHash forKey:@"lastestOfferListHash"];
    [self.defaults synchronize];
    
    //start pre-caching each offer's url page
    [self preloadOfferPageCache:objectNotation];
    NSLog(@"Sent offers list to delegate");
    [self.delegate didReceiveOffers:offers];
}
//tell its delegate about the error regarding fetching offers
- (void)tellDelegateAboutOfferFetchError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: FetchingManagerError code: FetchingManagerErrorOffersFetchCode userInfo: errorInfo];
    
    [self.delegate failedToReceiveOffersWithError:reportableError];
}

@end

NSString *FetchingManagerError = @"FetchingManagerError";
