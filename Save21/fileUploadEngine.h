//
//  fileUploadEngine.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-14.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface fileUploadEngine : MKNetworkEngine

-(MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path;

@end