//
//  fileUploadEngine.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-14.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "fileUploadEngine.h"

@implementation fileUploadEngine

-(MKNetworkOperation *)postDataToServer:(NSMutableDictionary *)params path:(NSString *)path {
    MKNetworkOperation *op = [self operationWithPath:path params:params httpMethod:@"POST" ssl:NO];
    return op;
}

@end