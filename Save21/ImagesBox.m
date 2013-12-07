//
//  ImagesBox.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-17.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "ImagesBox.h"
@interface ImagesBox()

@end

@implementation ImagesBox

@synthesize imageArray = _imageArray;

+(ImagesBox *)imageBox {
    static ImagesBox *single=nil;
    
    @synchronized(self)
    {
        if(!single)
        {
            single = [[ImagesBox alloc] init];
            single.imageArray = [[NSMutableArray alloc] init];
        }
        
    }
    return single;
}

-(NSMutableArray *)imageArray {
    if (_imageArray == nil)
        _imageArray = [[NSMutableArray alloc] init];
    return _imageArray;
}

-(void)addImage:(NSData *)image {
    [self.imageArray addObject:image];
}

-(void)emptyBox {
    self.imageArray = nil;
}

@end
