//
//  OfferViewController.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-07.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "OfferViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "keysAndUrls.h"

static Reachability *_reachability = nil;
BOOL _reachabilityOn;

static inline Reachability* defaultReachability () {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reachability = [Reachability reachabilityForInternetConnection];
    });
    
    return _reachability;
}

@interface OfferViewController ()

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;
@property (strong,nonatomic) MBProgressHUD *HUD;
@property (nonatomic,strong) NSString *cachesPath;
@property (nonatomic,strong) NSString *cacheFile;
@property (nonatomic,strong) NSString *urlFile;
@property (nonatomic,strong) NSFileManager* fileManager;
@property (weak, nonatomic) FetchingManagerCommunicator *communicatorEngine;
@property BOOL connected;
@end

@implementation OfferViewController
@synthesize webView = _webView;
@synthesize offerPageID = _offerPageID;
@synthesize offerPageURL = _offerPageURL;
@synthesize warningLabel = _warningLabel;
@synthesize labelHeight = _labelHeight;
@synthesize HUD = _HUD;
@synthesize communicatorEngine = _communicatorEngine;
@synthesize cacheFile = _cacheFile;
@synthesize cachesPath = _cachesPath;
@synthesize urlFile = _urlFile;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self startInternetReachability];
    
    [self refreshWebPage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.connected = YES;
    self.view.backgroundColor = ApplicationDelegate.darkColor;
    
    //create the back button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"Back.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 32, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.labelText = @"Please wait";
    self.HUD.detailsLabelText = @"Downloading offer details...";
    self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [self.view addSubview:self.HUD];
    
    NSLog (@"Received offer page ID %@ to display",self.offerPageID);
    self.webView.scalesPageToFit = NO;
    self.webView.delegate = self;
    
    self.cachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"offer_page_cache"];
    self.cacheFile = [self.cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.offerPageURL]];
    self.urlFile = [NSString stringWithFormat:@"http://%@/offer-pages/%@",WEBSERVICE_URL, self.offerPageURL];
    
    self.fileManager = [NSFileManager defaultManager];
    
    //Link the communicator to the appdelegate's communicator
    self.communicatorEngine = ApplicationDelegate.communicator;
    self.communicatorEngine.delegate = self;
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"FAIL TO LOAD WEB ARCHIVE");
    NSLog(@"%@",[error description]);
}

-(void)refreshWebPage {
    NSString *cachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"offer_page_cache"];
    NSString *cacheFile = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.offerPageURL]];
    
    NSURL *url = [NSURL fileURLWithPath:cacheFile];
    
    if (![self.fileManager fileExistsAtPath:cachesPath])
    {
        NSError* error = nil;
        NSLog(@"Creating directory: %@", cachesPath);
        if (![self.fileManager createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:&error])
            NSLog(@"Error creating directory: %@", [error description]);
    }
    NSLog(@"Trying to open web page from cache: %@",cacheFile);
    
    //Check to see if the file exists at the location
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFile]) {
        NSLog(@"Found web page in cache!");
        
        NSLog(@"Opening from: %@", [url description]);
        //Code for customising when the cache reloads would go here.
        [self.webView loadRequest:[NSURLRequest requestWithURL:url] ];
    }
    else
    {
        //If no cached webpaged exists
        NSLog(@"Need to download web page: %@",self.urlFile);
        [self downloadWebPage];
    }
}

-(void)downloadWebPage {
    [self.HUD show:YES];
    
    [self.communicatorEngine requestToDownloadFileFrom:self.urlFile toFile:self.cacheFile];
}

- (IBAction)refreshPressed:(UIBarButtonItem *)sender {
    [self downloadWebPage];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"Go to camera view"]) {
        if (self.connected)
            return YES;
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Take picture" message: @"It appears you are not online. This functions requires that you are online in order to use it. Please connect to internet and try again." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

#pragma mark - From FetchingManagerCommunicatorDelegate

-(void)downloadFileFailedWithError:(NSError *)error file:(NSString *)fileName {
    [self.HUD hide:YES];
    NSLog(@"Can't download web page: %@",fileName);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Loading Error" message: @"It appears you are not online. Please connect to the Internet to load this page." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    self.connected = NO;
    [self showNoInternetWarning];

}

-(void)downloadFileSuccess:(NSString *)fileName {
    NSURL *url = [NSURL fileURLWithPath:self.cacheFile];
    
    [self.HUD hide:YES];
    self.HUD.progress = 0.0f;
    NSLog(@"Web page %@ downloaded to %@",self.urlFile, self.cacheFile);
    
    //display the downloaded page in the webview
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    self.connected = YES;
    [self removeNoInternetWarning];
}

-(void)fileTransferOperationProgress:(double)percentage {
    self.HUD.progress = percentage;
}

#pragma mark Reachability Notification Handling
- (void)checkNetworkStatus {
    // called after network status changes
    NetworkStatus internetStatus = [defaultReachability() currentReachabilityStatus];
    switch (internetStatus) {
            
        case NotReachable: {
            NSLog(@"Unreachable");
            [self performSelector:@selector(showNoInternetWarning) withObject:nil afterDelay:0.1]; // performed with a small delay to avoid multiple notification causing stange jumping
            self.connected = NO;
            break;
        }
            
        case ReachableViaWiFi:
        case ReachableViaWWAN: {
            NSLog(@"Reachable");
            [self performSelector:@selector(removeNoInternetWarning) withObject:nil afterDelay:0.1]; // performed with a small delay to avoid multiple notification causing stange jumping
            self.connected = YES;
            //[self refreshWebPage];
            break;
        }
            
        default:
            break;
    }
}

- (void)startInternetReachability {
    
    if (!_reachabilityOn) {
        _reachabilityOn = TRUE;
        [defaultReachability() startNotifier];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus) name:kReachabilityChangedNotification object:nil];
    
    [self checkNetworkStatus];
}

- (void)stopInternerReachability {
    
    _reachabilityOn = FALSE;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
