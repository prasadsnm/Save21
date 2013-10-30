//
//  OffersArrayBuilder.m
//  Crave
//
//  Created by feiyang chen on 13-10-08.
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

@end
