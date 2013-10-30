//
//  NoAnimationSegue.m
//  Crave
//
//  Created by Leon Chen on 2013-10-20.
//

#import "NoAnimationSegue.h"

@implementation NoAnimationSegue

- (void) perform {
    
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dest = (UIViewController *)self.destinationViewController;
    
    [src.navigationController pushViewController:dest animated:NO];
}
@end
