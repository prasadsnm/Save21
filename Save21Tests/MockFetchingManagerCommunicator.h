//
//  MockFetchingManagerCommunicator.h
//  Save21
//
//  Created by Leon Chen on 2013-12-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "FetchingManagerCommunicator.h"

@interface MockFetchingManagerCommunicator : FetchingManagerCommunicator

- (BOOL)wasAskedToFetchOffersHash;

- (BOOL)wasAskedToFetchOffers;

- (BOOL)wasAskedToDownloadAFile;

- (BOOL)wasAskedToUploadImage;

- (BOOL)wasAskedToAddToReceiptTable;

- (BOOL)wasAskedToRegisterNewUser;
@end
