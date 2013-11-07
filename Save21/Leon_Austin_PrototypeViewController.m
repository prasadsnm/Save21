//
//  Leon_Austin_PrototypeViewController.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-06.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "Leon_Austin_PrototypeViewController.h"
#import <Parse/Parse.h>

@interface Leon_Austin_PrototypeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageLogo;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation Leon_Austin_PrototypeViewController
@synthesize activityIndicator = _activityIndicator;

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.imageLogo.clipsToBounds = YES;
    self.imageLogo.layer.borderWidth = 4.0f;
    self.imageLogo.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
    self.imageLogo.layer.cornerRadius = 55.0f;
    
    [self.activityIndicator startAnimating];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(aTime) userInfo:nil repeats:NO];
    
}

-(void)aTime
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        [self performSegueWithIdentifier:@"splashToOffers" sender:self];
    } else {
        // show the signup or login screen
        [self performSegueWithIdentifier:@"showSignIn" sender:self];
    }
    [self.activityIndicator stopAnimating];
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
