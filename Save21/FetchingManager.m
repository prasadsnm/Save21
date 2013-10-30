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

@implementation FetchingManager
@synthesize flOperation = _flOperation;
@synthesize flUploadEngine = _flUploadEngine;

-(void)fetchOffers
{
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"request_offers", nil];
    self.flOperation = [self.flUploadEngine postDataToServer:postParams path:@"/indexAPI.php"];
    
    __weak typeof(self) weakSelf = self;
    [self.flOperation addCompletionHandler:^(MKNetworkOperation *operation)
        {
            NSLog(@"Offer List request success!");
            //handle a successful 200 response
            NSDictionary *responseDict = [operation responseJSON];
            //NSLog(@"%@",[responseDict description]);
            
            [weakSelf receivedOffersJSON:responseDict];
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"%@", error);
            [weakSelf.delegate failedToReceiveOffers];
        }];
    [self.flUploadEngine enqueueOperation:self.flOperation];
}

#pragma mark - FetchingManagerDelegate

-(void)receivedOffersJSON:(NSDictionary *)objectNotation {
    NSArray *offers = [OffersArrayBuilder offersFromJSON:objectNotation];
    
   [self.delegate didReceiveOffers:offers];

}
@end

