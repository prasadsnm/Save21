//
//  FakeOffersList.h
//  Save21
//
//  Created by Leon Chen on 12/6/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "OffersList.h"

@interface FakeOffersList : OffersList

@property (nonatomic, strong) NSArray *fakeOffersArray;

-(void)initializeOffersList:(NSArray *)receivedOffers;

+(FakeOffersList *)offersList;

@end
