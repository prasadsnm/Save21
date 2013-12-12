//
//  OfferTableViewDataSource.h
//  Save21
//
//  Created by Leon Chen on 12/9/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class singleOffer;

@interface OfferTableViewDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>

- (void)setOffers: (NSArray *)newOffers;

- (void)setDictionaryOfSelectedOfferIDs: (NSMutableDictionary *)newDictionary;

- (singleOffer *)offerForIndexPath:(NSIndexPath *)indexPath;

@property BOOL showCheckMarks;

@property (strong, nonatomic) NSMutableDictionary *DictionaryOfSelectedOfferIDs;

@end

extern NSString *OfferTableDidSelectOfferNotification;