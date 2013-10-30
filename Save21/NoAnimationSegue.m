//
//  NoAnimationSegue.m
//  Save21
//
//  Created by Feiyang Chen on 2013-10-20.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "NoAnimationSegue.h"

@implementation NoAnimationSegue

- (void) perform {
    
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dest = (UIViewController *)self.destinationViewController;
    
    [src.navigationController pushViewController:dest animated:NO];
}
@end
