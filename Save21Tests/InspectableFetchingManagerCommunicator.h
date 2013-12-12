//
//  InspectableFetchingManagerCommunicator.h
//  Save21
//
//  Created by Leon Chen on 2013-12-07.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "FetchingManagerCommunicator.h"

@interface InspectableFetchingManagerCommunicator : FetchingManagerCommunicator

-(NSMutableDictionary *)paramToSendToAPI;
-(NSString *)APIURLAddress;

-(NSString *)fileToDownload;
-(NSString *)filePathToDownloadTo;

@end