//
//  FakeImagesBox.h
//  Save21
//I
//  Created by Leon Chen on 2013-12-05.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImagesBox.h"

@interface FakeImagesBox : ImagesBox

@property (nonatomic, strong) NSMutableArray *mockImageArray;

-(void)addImage:(NSData *)image;

-(void)emptyBox;

+(FakeImagesBox *)imageBox;

@end
