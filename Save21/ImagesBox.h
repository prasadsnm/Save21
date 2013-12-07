//
//  ImagesBox.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-17.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagesBox : NSObject

@property (nonatomic, strong) NSMutableArray *imageArray;

-(void)addImage:(NSData *)image;

-(void)emptyBox;

+(ImagesBox *)imageBox;

@end