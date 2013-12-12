//
//  OffersArrayBuilder.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

//TESTED

#import "OffersArrayBuilder.h"
#import "singleOffer.h"

@implementation OffersArrayBuilder

+ (NSArray *)offersFromJSON:(NSDictionary *)objectNotation error: (NSError **)error;
{
    NSParameterAssert(objectNotation != nil);
    
    NSArray *results = [objectNotation valueForKey:@"offers"];
    
    if (results == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:OffersArrayBuilderErrorDomain code: OffersArrayInvalidJSONError userInfo:nil];
        }
        return nil;
    }
    
    NSMutableArray *offers = [[NSMutableArray alloc] init];
    
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

+ (NSArray *)getOffersPageURLs:(NSDictionary *)objectNotation error: (NSError **)error;
{
    NSParameterAssert(objectNotation != nil);

    NSArray *results = [objectNotation valueForKey:@"offers"];
    
    if (results == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:OffersArrayBuilderErrorDomain code: OffersArrayInvalidJSONError userInfo:nil];
        }
        return nil;
    }
    
    NSMutableArray *offersPageURLs = [[NSMutableArray alloc] init];
    
    for (NSDictionary *offerDic in results) {
        NSString *offerPageURL;
        offerPageURL = [offerDic valueForKey:@"offerurl"];
        
        [offersPageURLs addObject:offerPageURL];
    }
    
    return offersPageURLs;
}

@end

NSString *OffersArrayBuilderErrorDomain = @"OffersArrayBuilderErrorDomain";
