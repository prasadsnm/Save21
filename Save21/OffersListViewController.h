//
//  OffersListViewController.h
//  Crave
//
//  Created by Feiyang Chen on 13-10-08.
//

#import <UIKit/UIKit.h>
#import "IRevealControllerProperty.h"
#import "AOScrollerView.h"
#import "FetchingManagerDelegate.h"

@interface OffersListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,IRevealControllerProperty,ValueClickDelegate,FetchingManagerDelegate>

@end
