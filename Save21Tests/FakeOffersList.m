//
//  FakeOffersList.m
//  Save21
//
//  Created by Leon Chen on 12/6/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "FakeOffersList.h"

@implementation FakeOffersList
@synthesize fakeOffersArray = _fakeOffersArray;

+(FakeOffersList *)offersList{
    static FakeOffersList *single=nil;
    
    @synchronized(self)
    {
        if(!single)
        {
            single = [[FakeOffersList alloc] init];
        }
        
    }
    return single;
}

-(NSArray *)fakeOffersArray {
    if (_fakeOffersArray == nil)
        _fakeOffersArray = [[NSArray alloc] init];
    return _fakeOffersArray;
}

-(void)initializeOffersList:(NSArray *)receivedOffers {
    if (receivedOffers)
        self.fakeOffersArray = receivedOffers;
}

@end
