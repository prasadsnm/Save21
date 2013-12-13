//
//  OffersList.m
//  Save21
//
//  Created by Feiyang Chen on 2013-10-19.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

//TESTED

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
            single.offersArray = [[NSArray alloc] init];
        }
        
    }
    return single;
}

-(NSArray *)offersArray {
    if (_offersArray == nil)
        _offersArray = [[NSArray alloc] init];
    return _offersArray;
}

-(void)initializeOffersList:(NSArray *)receivedOffers {
    if (receivedOffers)
        self.offersArray = receivedOffers;
}

-(void)emptyBox {
    self.offersArray = nil;
}

@end

