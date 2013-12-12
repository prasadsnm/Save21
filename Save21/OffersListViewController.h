//
//  OffersListViewController.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-08.
//

#import <UIKit/UIKit.h>
#import "IRevealControllerProperty.h"
#import "AOScrollerView.h"
#import "FetchingManagerDelegate.h"
#import "OfferTableViewDataSource.h"

@interface OffersListViewController : UIViewController <IRevealControllerProperty,ValueClickDelegate,FetchingManagerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *offersListTable;

@property (weak, nonatomic) OfferTableViewDataSource *dataSourceAndDelegate;

- (void)userDidSelectOfferNotification: (NSNotification *)note;

@end
