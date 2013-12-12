//
//  MockFetchingManagerDelegate.m
//  Save21
//
//  Created by Leon Chen on 2013-12-06.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "MockFetchingManagerDelegate.h"

@implementation MockFetchingManagerDelegate
@synthesize fetchedOffers = _fetchedOffers;
@synthesize fetchError = _fetchError;

-(void)didReceiveOffers:(NSArray *)offers {
    NSLog(@"Received offers from FetchingManager");
    self.fetchedOffers = offers;
    NSLog(@"%@",[offers description]);
}

-(void)failedToReceiveOffersWithError:(NSError *)error {
    self.fetchError = error;
}
@end
