//
//  singleOffer.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-08.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

//TESTED

#import <Foundation/Foundation.h>

@interface singleOffer : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *description;
@property (copy, nonatomic) NSString *properties;
@property (copy, nonatomic) NSString *pictureURL;
@property (copy, nonatomic) NSString *offerid;
@property (copy, nonatomic) NSString *offerurl;
@property NSInteger total_offered;
@property NSInteger num_of_valid_claims;
@property float rebate_amount;
@property (copy, nonatomic) NSString *bannerPictureURL;

@end
