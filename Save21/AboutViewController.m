//
//  AboutViewController.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-07.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "AboutViewController.h"
#import "keysAndUrls.h"
#import "OffersListRootController.h"

@interface AboutViewController ()
@property (nonatomic,weak) IBOutlet UIWebView *webView;

@end

@implementation AboutViewController
@synthesize webView = _webView;

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ABOUT_PAGE_URL]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"backToMenu"]) {
        [segue.destinationViewController setShouldShowSliderBarAtStart:YES];
    }
}

@end
