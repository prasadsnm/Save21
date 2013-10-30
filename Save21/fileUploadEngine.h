//
//  fileUploadEngine.h
//  Crave
//
//  Created by feiyang chen on 13-10-14.
//

#import "MKNetworkEngine.h"

@interface fileUploadEngine : MKNetworkEngine

-(MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path;

@end
