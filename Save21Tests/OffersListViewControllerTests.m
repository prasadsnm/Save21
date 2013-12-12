//
//  OffersListViewControllerTests.m
//  Save21
//
//  Created by Leon Chen on 12/9/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "OffersListViewController.h"
#import "OfferViewController.h"
#import "OfferTableViewDataSource.h"
#import "singleOffer.h"

static const char *notificationKey = "OffersListViewControllerTestsAssociatedNotificationKey";

@implementation OffersListViewController (TestNotificationDelivery)

- (void)userDidSelectOfferNotification: (NSNotification *)note {
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}

@end

@interface OffersListViewControllerTests : XCTestCase {
    OffersListViewController *viewController;
    UITableView *tableView;
    OfferTableViewDataSource <UITableViewDataSource,UITableViewDelegate> *dataSource;
    UINavigationController *navController;
}

@end

@implementation OffersListViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    viewController = [[OffersListViewController alloc] init];
    tableView = [[UITableView alloc] init];
    viewController.offersListTable = tableView;
    dataSource = [[OfferTableViewDataSource alloc] init];
    viewController.dataSourceAndDelegate = dataSource;
    objc_removeAssociatedObjects(viewController);
    navController = [[UINavigationController alloc] initWithRootViewController:viewController];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    objc_removeAssociatedObjects(viewController);
    viewController = nil;
    tableView = nil;
    dataSource = nil;
    navController = nil;
    [super tearDown];
}

- (void)testViewControllerHasATableViewProperty {
    objc_property_t tableViewProperty = class_getProperty([viewController class], "offersListTable");
    XCTAssertTrue(tableViewProperty != NULL, @"OffersListViewController needs a table view");
}

- (void)testViewControllerHasADataSourceProperty {
    objc_property_t dataSourceProperty = class_getProperty([viewController class], "dataSourceAndDelegate");
    XCTAssertTrue(dataSourceProperty != NULL, @"OffersListViewController needs a data source");
}

- (void)testViewControllerConnectDataSourceInViewDidLoad {
    [viewController viewDidLoad];
    XCTAssertEqualObjects([tableView dataSource], dataSource, @"View controller should have set the table view's data source");
}

- (void)testOfferTableDataSourceCanReceiveAListOfTopics {
    OfferTableViewDataSource *dataSource = [[OfferTableViewDataSource alloc] init];
    singleOffer *sampleOffer = [[singleOffer alloc] init];
    sampleOffer.name = @"Test Offer";
    sampleOffer.description = @"Test Offer description";
    sampleOffer.properties = @"Test Offer properties";
    sampleOffer.pictureURL = @"http://test.com/thumbnail.jpg";
    sampleOffer.offerid = @"12345";
    sampleOffer.offerurl = @"http://test.com/offer.html";
    sampleOffer.total_offered = 100;
    sampleOffer.num_of_valid_claims = 10;
    sampleOffer.rebate_amount = 2.5;
    sampleOffer.bannerPictureURL = @"http://test.com/banner.jpg";
    
    NSArray *offerList = [NSArray arrayWithObject: sampleOffer];
    XCTAssertNoThrow([dataSource setOffers: offerList], @"The data source needs a list of topics");
}

- (void)testViewControllerConnectsDelegateInViewDidLoad {
    [viewController viewDidLoad];
    XCTAssertEqualObjects([tableView delegate], dataSource, @"View controller should have set the table view's data source");
}

- (void)testDefaultStateOfViewControllerDoesNotReceiveNotifications {
    [[NSNotificationCenter defaultCenter] postNotificationName:OfferTableDidSelectOfferNotification object:nil userInfo:nil];
    XCTAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"Notification should not be received before -viewDidAppear:");
}

-(void)testViewControllerReceivesTableSelectionNotificationAfterViewDidAppear {
    [viewController viewDidAppear: NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:OfferTableDidSelectOfferNotification object:nil userInfo:nil];
    XCTAssertNotNil(objc_getAssociatedObject(viewController, notificationKey), @"The view model should handle selection notifications after viewDidAppear");
}

-(void)testViewControllerDoesNotReceiveTableSelectNotificationAfterViewWillDisappear {
    [viewController viewDidAppear:NO];
    [viewController viewWillDisappear:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:OfferTableDidSelectOfferNotification object:nil userInfo:nil];
    XCTAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"After viewWillDisappear is called, view controller should no longer respond to offer selection notification");
}

@end
