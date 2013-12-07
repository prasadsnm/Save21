//
//  MockFetchingManacgerCommunicator.h
//  Save21
//
//  Created by Leon Chen on 2013-12-06.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchingManagerCommunicator.h"

@interface MockFetchingManagerCommunicator : FetchingManagerCommunicator

- (BOOL)wasAskedToFetchOffers;
- (BOOL)wasAskedToDownloadAFile;

@end
