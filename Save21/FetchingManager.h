//
//  FetchingManager.h
//  Crave
//
//  Created by feiyang chen on 13-10-08.
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
