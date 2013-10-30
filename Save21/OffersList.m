//
//  OffersList.m
//  Crave
//
//  Created by feiyang chen on 2013-10-19.
//

#import "OffersList.h"

@implementation OffersList
@synthesize offersArray = _offersArray;

+(OffersList *)offersList{
    static OffersList *single=nil;
    
    @synchronized(self)
    {
        if(!single)
        {
            single = [[OffersList alloc] init];
            
        }
        
    }
    return single;
}

-(void)initializeOffersList:(NSArray *)receivedOffers {
    if (!receivedOffers)
        self.offersArray = receivedOffers;
}

@end

