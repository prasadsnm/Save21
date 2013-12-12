//
//  OfferViewController.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-07.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferViewController : UIViewController <UIWebViewDelegate,FetchingManagerCommunicatorDelegate>

@property (nonatomic,weak) IBOutlet UIWebView *webView;
@property (nonatomic,strong) NSString *offerPageID;
@property (nonatomic,strong) NSString *offerPageURL;
@end
