//
//  FirstTimeViewController.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-07.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "FirstTimeViewController.h"
#import "keysAndUrls.h"

@interface FirstTimeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;

@end

@implementation FirstTimeViewController
@synthesize getStartedButton = _getStartedButton;

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    //self.navigationItem.leftBarButtonItem=nil;
    //self.navigationItem.hidesBackButton=YES;
    
    self.getStartedButton.backgroundColor = ApplicationDelegate.darkColor;
    self.getStartedButton.layer.cornerRadius = 3.0f;
    self.getStartedButton.titleLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:20.0f];
    [self.getStartedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.getStartedButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
