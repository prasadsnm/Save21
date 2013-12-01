//
//  singleOffer.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface singleOffer : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *properties;
@property (strong, nonatomic) NSString *pictureURL;
@property (strong, nonatomic) NSString *offerid;
@property (strong, nonatomic) NSString *offerurl;
@property (strong, nonatomic) NSNumber *total_offered;
@property (strong, nonatomic) NSNumber *num_of_valid_claims;
@property (strong, nonatomic) NSNumber *rebate_amount;
@property (strong, nonatomic) NSString *bannerPictureURL;

@end
