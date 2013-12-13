//
//  OffersList.h
//  Save21
//
//  Created by Feiyang Chen on 2013-10-19.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

//TESTED

#import <Foundation/Foundation.h>

@interface OffersList : NSObject

@property (nonatomic, strong) NSArray *offersArray;

-(void)initializeOffersList:(NSArray *)receivedOffers;

+(OffersList *)offersList;

-(void)emptyBox;

@end
