//
//  InspectableFetchingManagerCommunicator.m
//  Save21
//
//  Created by Leon Chen on 2013-12-07.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "InspectableFetchingManagerCommunicator.h"

@implementation InspectableFetchingManagerCommunicator 

-(NSMutableDictionary *)paramToSendToAPI {
    return apiParameters;
}

-(NSString *)APIURLAddress {
    return webAPIURL;
}

-(NSString *)fileToDownload{
    return fileToDownloadURL;
}

-(NSString *)filePathToDownloadTo{
    return filePathToDownloadTo;
}


@end
