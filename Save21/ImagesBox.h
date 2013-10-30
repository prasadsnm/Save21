//
//  ImagesBox.h
//  Crave
//
//  Created by feiyang chen on 13-10-17.
//

#import <Foundation/Foundation.h>

@interface ImagesBox : NSObject
@property (nonatomic, strong) NSMutableArray *imageArray;

-(void)addImage:(NSData *)image;
-(void)emptyBox;

+(ImagesBox *)imageBox;
@end