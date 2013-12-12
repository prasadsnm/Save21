//
//  FetchingManager.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

//TESTED

#import <Foundation/Foundation.h>
#import "FetchingManagerDelegate.h"
#import "FetchingManagerCommunicatorDelegate.h"

@class FetchingManagerCommunicator;
@class OffersArrayBuilder;
@class singleOffer;

@interface FetchingManager : NSObject <FetchingManagerCommunicatorDelegate>

@property (weak, nonatomic) id<FetchingManagerDelegate> delegate;

@property (weak, nonatomic) FetchingManagerCommunicator *communicator;

//fetch the lastest offer's JSON file, return the parsed dictionary to the delegate
-(void)fetchOffers;

@end

extern NSString *FetchingManagerError;

enum {
    FetchingManagerErrorOffersFetchCode,
    FetchingManagerErrorOffersHashFetchCode,
};