//
//  fileUploadEngine.m
//  Crave
//
//  Created by feiyang chen on 13-10-14.
//

#import "fileUploadEngine.h"

@implementation fileUploadEngine

-(MKNetworkOperation *)postDataToServer:(NSMutableDictionary *)params path:(NSString *)path {
    MKNetworkOperation *op = [self operationWithPath:path params:params httpMethod:@"POST" ssl:NO];
    return op;
}

@end
