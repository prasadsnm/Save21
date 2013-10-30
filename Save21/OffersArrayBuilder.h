//
//  OffersArrayBuilder.h
//  Crave
//
//  Created by feiyang chen on 13-10-08.
//

#import <Foundation/Foundation.h>

@interface OffersArrayBuilder : NSObject

+ (NSArray *)offersFromJSON:(NSDictionary *)objectNotation;

@end
