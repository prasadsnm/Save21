//
//  FetchingManagerDelegate.h
//  Crave
//
//  Created by feiyang chen on 13-10-08.
//

#import <Foundation/Foundation.h>

@protocol FetchingManagerDelegate

- (void)didReceiveOffers:(NSArray *)offers;
- (void)failedToReceiveOffers;

@end
