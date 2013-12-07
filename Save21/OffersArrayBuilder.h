//
//  OffersArrayBuilder.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OffersArrayBuilder : NSObject

+ (NSArray *)offersFromJSON:(NSDictionary *)objectNotation error: (NSError **)error;

+ (NSArray *)getOffersPageURLs:(NSDictionary *)objectNotation error: (NSError **)error;

@end

extern NSString *OffersArrayBuilderErrorDomain;

enum {
    OffersArrayInvalidJSONError,
};