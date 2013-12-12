//
//  MockFetchingManagerDelegate.h
//  Save21
//
//  Created by Leon Chen on 2013-12-06.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchingManagerDelegate.h"

@interface MockFetchingManagerDelegate : NSObject <FetchingManagerDelegate>

@property (strong) NSArray *fetchedOffers;

@property (strong) NSError *fetchError;

@end
