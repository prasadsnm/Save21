//
//  OfferViewController.m
//  Crave
//
//  Created by Feiyang Chen on 13-10-07.
//

#import "OfferViewController.h"
#import "Reachability.h"

@interface OfferViewController () {
    BOOL connected;
}

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;
@end

@implementation OfferViewController
@synthesize webView = _webView;
@synthesize urlString = _urlString;
@synthesize warningLabel = _warningLabel;
@synthesize labelHeight = _labelHeight;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Add Observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    
    NSLog (@"Received %@ URL to display",self.urlString);
    self.webView.scalesPageToFit = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    connected = YES;
}

-(void)showNoInternetWarning {
    self.labelHeight.constant = 35;
    
    [self animateConstraints];
}

-(void)removeNoInternetWarning {
    self.labelHeight.constant = 0;
    
    [self animateConstraints];
}

- (void)animateConstraints
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"Go to camera view"]) {
        if (connected)
            return YES;
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Take picture" message: @"It appears you are not online. This functions requires that you are online in order to use it. Please connect to internet and try again." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

#pragma mark Notification Handling
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable] || [reachability isReachableViaWWAN] || [reachability isReachableViaWiFi]) {
        NSLog(@"Reachable");
        [self removeNoInternetWarning];
        connected = YES;
    } else {
        NSLog(@"Unreachable");
        if (![reachability isReachable]) {
            [self showNoInternetWarning];
            connected = NO;
        }
    }
}
@end
