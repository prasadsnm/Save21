//
//  FetchingManager.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchingManagerDelegate.h"
#import "FetchingManagerCommunicator.h"

@class OffersFetcher;

@interface FetchingManager : NSObject

@property (weak, nonatomic) id<FetchingManagerDelegate> delegate;

@property (weak, nonatomic) FetchingManagerCommunicator *communicatorEngine;

//fetch the lastest offer's JSON file, return the parsed dictionary to the delegate
-(void)fetchOffers;

@end

extern NSString *FetchingManagerError;

enum {
    FetchingManagerErrorOffersToFetchCode,
    FetchingManagerErrorNoInternetCode,
};