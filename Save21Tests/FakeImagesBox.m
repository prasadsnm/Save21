//
//  FakeImagesBox.m
//  Save21
//
//  Created by Leon Chen on 2013-12-05.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "FakeImagesBox.h"

@implementation FakeImagesBox
@synthesize mockImageArray = _mockImageArray;

+(FakeImagesBox *)imageBox {
    static FakeImagesBox *single=nil;
    
    @synchronized(self)
    {
        if(!single)
        {
            single = [[FakeImagesBox alloc] init];
        }
    }
    return single;
}

-(NSMutableArray *)mockImageArray {
    if (_mockImageArray == nil)
        _mockImageArray = [[NSMutableArray alloc] init];
    return _mockImageArray;
}

-(void)addImage:(NSData *)image {
    [self.mockImageArray addObject:image];
}

-(void)emptyBox {
    self.mockImageArray = nil;
}

@end
