//
//  SidebarController.h
//  ADVFlatUI
//
//  Created by Tope on 05/06/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "IRevealControllerProperty.h"

@interface SidebarController : UIViewController <UITableViewDataSource, UITableViewDelegate,IRevealControllerProperty>

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, weak) IBOutlet UILabel* profileNameLabel;

@property (nonatomic, weak) IBOutlet UILabel* profileLocationLabel;

@property (nonatomic, weak) IBOutlet UIImageView* profileImageView;

@end
