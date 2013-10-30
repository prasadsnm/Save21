//
//  FetchingManager.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchingManagerDelegate.h"
#import "fileUploadEngine.h"

@class OffersFetcher;

@interface FetchingManager : NSObject

@property (weak, nonatomic) id<FetchingManagerDelegate> delegate;

@property (nonatomic,strong) fileUploadEngine *flUploadEngine;
@property (nonatomic,strong) MKNetworkOperation *flOperation;

-(void)fetchOffers;

@end
