//
//  SignInViewController.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-06.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation SignInViewController
@synthesize logoImage = _logoImage;
@synthesize signInButton = _signInButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.logoImage.clipsToBounds = YES;
    self.logoImage.layer.borderWidth = 4.0f;
    self.logoImage.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
    self.logoImage.layer.cornerRadius = 55.0f;
    
    self.view.backgroundColor = ApplicationDelegate.mainColor;
    
    self.signInButton.backgroundColor = ApplicationDelegate.darkColor;
    self.signInButton.layer.cornerRadius = 3.0f;
    self.signInButton.titleLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:20.0f];
    [self.signInButton setTitle:@"SIGN IN HERE" forState:UIControlStateNormal];
    [self.signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signInButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
}

- (void)viewDidUnload
{
    [self setLogoImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)signInButtonPressed {
    //go to the next screen
    [self performSegueWithIdentifier:@"Go To Login" sender:self];
}
@end
