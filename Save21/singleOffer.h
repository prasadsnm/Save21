//
//  singleOffer.h
//  Crave
//
//  Created by feiyang chen on 13-10-08.
//

#import <Foundation/Foundation.h>

@interface singleOffer : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *properties;
@property (strong, nonatomic) NSString *pictureURL;
@property (strong, nonatomic) NSString *offerid;
@property (strong, nonatomic) NSString *offerurl;
@property int num_left;
@property float rebate_amount;
@property (strong, nonatomic) NSString *bannerPictureURL;

@end
