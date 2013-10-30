//
//  OffersList.m
//  Save21
//
//  Created by Feiyang Chen on 2013-10-19.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
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

