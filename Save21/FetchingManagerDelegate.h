//
//  FetchingManagerDelegate.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FetchingManagerDelegate <NSObject>

- (void)didReceiveOffers:(NSArray *)offers;

- (void)failedToReceiveOffersWithError: (NSError *)error;

@end
