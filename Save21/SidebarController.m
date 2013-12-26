//
//  SidebarController.m
//  ADVFlatUI
//
//  Created by Tope on 05/06/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "SidebarController.h"
#import "SidebarCell2.h"
#import <QuartzCore/QuartzCore.h>
#import "SideMenuUtil.h"

@interface SidebarController ()

@property (nonatomic, strong) NSArray* items;

@end

@implementation SidebarController
@synthesize revealController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.view.backgroundColor = ApplicationDelegate.sidemenuBackgroundColor;
    // 设置自身窗口尺寸
	self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    UINavigationController* homeNC = [self.storyboard instantiateViewControllerWithIdentifier:@"OffersListViewController"];
    NSLog(@"instantiateViewControllerWithIdentifier: %@", homeNC);
    [SideMenuUtil addNavigationGesture:homeNC revealController:revealController];
    //homeNC.revealController = revealController;
    [SideMenuUtil setRevealControllerProperty:homeNC revealController:revealController];
    revealController.contentViewController = homeNC;
    
    self.tableView.backgroundColor = ApplicationDelegate.sidemenuBackgroundColor;
    self.tableView.separatorColor = [UIColor clearColor];
    
    NSString* fontName = @"Avenir-Black";
    NSString* boldFontName = @"Avenir-BlackOblique";
    
    self.profileNameLabel.textColor = [UIColor whiteColor];
    self.profileNameLabel.font = [UIFont fontWithName:fontName size:14.0f];
    self.profileNameLabel.text = [NSString stringWithFormat:@"%@ %@", [[PFUser currentUser] objectForKey:@"firstName"],[[PFUser currentUser] objectForKey:@"lastName"]];
    
    self.profileLocationLabel.textColor = [UIColor whiteColor];
    self.profileLocationLabel.font = [UIFont fontWithName:boldFontName size:12.0f];
    self.profileLocationLabel.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectForKey:@"city"]];
    
    self.profileImageView.image = [UIImage imageNamed:@"user icon 130px.png"];
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
    self.profileImageView.layer.cornerRadius = 25.0f;
    
    
    //NSDictionary* object1 = [NSDictionary dictionaryWithObjects:@[ @"Receipts In Progress", [NSString stringWithFormat:@"%@",[[PFUser currentUser] objectForKey:@"numberOfReceiptsInProcess"]], @"envelope" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object2 = [NSDictionary dictionaryWithObjects:@[ @"Help", @"0", @"Question Mark" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object3 = [NSDictionary dictionaryWithObjects:@[ @"Account", @"0", @"Phone Icon" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object4 = [NSDictionary dictionaryWithObjects:@[ @"Settings", @"0", @"Gear Icon" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object5 = [NSDictionary dictionaryWithObjects:@[ @"Logout", @"0", @"Back" ] forKeys:@[ @"title", @"count", @"icon" ]];
    
    self.items = @[object2, object3, object4, object5];
	
}

- (void)viewWillAppear:(BOOL)animated {
	// 设置自身窗口尺寸
	self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
    
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SidebarCell2* cell = [tableView dequeueReusableCellWithIdentifier:@"SidebarCell2"];
    
    NSDictionary* item = self.items[indexPath.row];
    
    cell.titleLabel.text = item[@"title"];
    cell.iconImageView.image = [UIImage imageNamed:item[@"icon"]];
    
    NSString* count = item[@"count"];
    if(![count isEqualToString:@"0"]){
        cell.countLabel.text = count;
    }
    else{
        cell.countLabel.alpha = 0;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    enum SideBarMenuRows {
        HelpRow = 0,
        AccountRow = 1,
        SettingsRow = 2,
        LogOutRow = 3
    };
    
    NSUInteger row = [indexPath row];
    
    switch (row) {
        case HelpRow:
            revealController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpNavigationController"];
            [revealController toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
            break;
        case AccountRow:
            revealController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountInfoNavigationController"];
            [revealController toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
            break;
        case SettingsRow:
            revealController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsNavigationController"];
            [revealController toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
            break;
        case LogOutRow:
            [PFUser logOut];
            
            revealController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RootNavigationController"];
            [revealController toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
