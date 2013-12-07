//
//  MockFetchingManacgerCommunicator.m
//  Save21
//
//  Created by Leon Chen on 2013-12-06.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "MockFetchingManagerCommunicator.h"

@implementation MockFetchingManagerCommunicator {
    BOOL wasAskedToFetchOffer;
    BOOL wasAskedToDownloadAFile;
}

-(MKNetworkOperation *)postDataToServer:(NSMutableDictionary *)params path:(NSString *)path {
    wasAskedToFetchOffer = YES;
    return nil;
}

-(MKNetworkOperation*) downloadFileFrom:(NSString*) remoteURL toFile:(NSString*) filePath {
    wasAskedToFetchOffer = YES;
    return nil;
}

- (BOOL)wasAskedToFetchOffers {
    return wasAskedToFetchOffer;
}

- (BOOL)wasAskedToDownloadAFile {
    return wasAskedToDownloadAFile;
}

@end
