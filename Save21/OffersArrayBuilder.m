//
//  OffersArrayBuilder.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "OffersArrayBuilder.h"
#import "singleOffer.h"

@implementation OffersArrayBuilder

+ (NSArray *)offersFromJSON:(NSDictionary *)objectNotation
{
    NSMutableArray *offers = [[NSMutableArray alloc] init];
    
    NSArray *results = [objectNotation valueForKey:@"offers"];
    NSLog(@"Count %d", results.count);
    
    for (NSDictionary *offerDic in results) {
        singleOffer *offer = [[singleOffer alloc] init];
        
        for (NSString *key in offerDic) {
            if ([offer respondsToSelector:NSSelectorFromString(key)]) {
                [offer setValue:[offerDic valueForKey:key] forKey:key];
            }
        }
        
        [offers addObject:offer];
    }
    
    return offers;
}

+(NSArray *)getOffersPageURLs:(NSDictionary *)objectNotation {
    NSMutableArray *offersPageURLs = [[NSMutableArray alloc] init];
    
    NSArray *results = [objectNotation valueForKey:@"offers"];
    
    for (NSDictionary *offerDic in results) {
        NSString *offerPageURL;
        offerPageURL = [offerDic valueForKey:@"offerurl"];
        
        [offersPageURLs addObject:offerPageURL];
    }
    
    return offersPageURLs;
}

+ (NSString *)getOffersBatchID:(NSDictionary *)objectNotation {
    NSString *batchID = [objectNotation valueForKey:@"batch_ID"];
    
    return batchID;
}
@end
