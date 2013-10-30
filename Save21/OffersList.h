//
//  OffersList.h
//  Crave
//
//  Created by feiyang chen on 2013-10-19.
//

#import <Foundation/Foundation.h>

@interface OffersList : NSObject
@property (nonatomic, strong) NSArray *offersArray;

-(void)initializeOffersList:(NSArray *)receivedOffers;

+(OffersList *)offersList;
@end
