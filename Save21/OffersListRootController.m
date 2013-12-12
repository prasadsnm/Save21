//
//  OffersListRootController.m
//  Save21
//
//  Created by Feiyang Chen on 2013-10-25.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "OffersListRootController.h"
#import "SidebarController.h"
#import "GHRevealViewController.h"

@interface OffersListRootController ()

@end

@implementation OffersListRootController
@synthesize shouldShowSliderBarAtStart = _shouldShowSliderBarAtStart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SidebarController* menuVc = [self.storyboard instantiateViewControllerWithIdentifier:@"SidebarController"];
    UIColor *bgColor = [UIColor whiteColor];
    
    GHRevealViewController* revealController = [[GHRevealViewController alloc] initWithNibName:nil bundle:nil];
    revealController.view.backgroundColor = bgColor;
    
    // 绑定.
    menuVc.revealController = revealController;
    revealController.sidebarViewController = menuVc;
    
    // show.
    revealController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:revealController animated:YES completion:^{
        //show sider bar
        //if (self.shouldShowSliderBarAtStart)
            //[revealController toggleSidebar:YES duration:0];
    }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
