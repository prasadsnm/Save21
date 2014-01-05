//
//  OfferTableViewDataSource.m
//  Save21
//
//  Created by Leon Chen on 12/9/2013.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "OfferTableViewDataSource.h"
#import "singleOffer.h"
#import "OfferTableCell.h"
#import "keysAndUrls.h"

NSString *offerCellReuseIdentifier = @"offerCell";

@interface OfferTableViewDataSource ()

@property (strong,nonatomic) NSArray *offers;

@end

@implementation OfferTableViewDataSource
@synthesize offers = _offers;
@synthesize showCheckMarks = _showCheckMarks;
@synthesize DictionaryOfSelectedOfferIDs = _DictionaryOfSelectedOfferIDs;

-(void)setOffers:(NSArray *)newOffers {
    _offers = newOffers;
    self.DictionaryOfSelectedOfferIDs = [[NSMutableDictionary alloc] init];
}

-(singleOffer *)offerForIndexPath:(NSIndexPath *)indexPath {
    return [self.offers objectAtIndex: [indexPath row]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSParameterAssert(section == 0);
    return [self.offers count];
}

-(OfferTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert([indexPath section] == 0);
    NSParameterAssert([indexPath row] < [self.offers count] );
    
    OfferTableCell *offerCell = [tableView dequeueReusableCellWithIdentifier:offerCellReuseIdentifier];
    
	if (!offerCell) {
		offerCell = [[OfferTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:offerCellReuseIdentifier];
	}
    
    singleOffer *currentOffer = [self offerForIndexPath: indexPath];
    
    offerCell.nameLabel.text = currentOffer.name;
	offerCell.updateLabel.text = currentOffer.description;
    offerCell.commentCountLabel.text = [NSString stringWithFormat:@"$%.2f",currentOffer.rebate_amount];
    
    if (currentOffer.total_offered == -1)
        offerCell.dateLabel.text = [NSString stringWithFormat:@"Unlimited"];
    else {
        if ( ( currentOffer.total_offered - currentOffer.num_of_valid_claims ) < 1 )
            offerCell.dateLabel.text = @"SOLD OUT";
        else
            offerCell.dateLabel.text = [NSString stringWithFormat:@"Remaining: %ld",(currentOffer.total_offered - currentOffer.num_of_valid_claims )];
    }
    
    //draw check mark on selected cell
    if ( self.showCheckMarks && [self.DictionaryOfSelectedOfferIDs objectForKey:currentOffer.offerid] )
    {
        offerCell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        offerCell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    //set the picture for each cell
    NSString *thumbnail_URL = [NSString stringWithFormat:@"%@%@", IMAGE_FOLDER_URL,currentOffer.pictureURL];
    
    [offerCell.profileImageView setImageFromUrl:YES withUrl:thumbnail_URL];
    
	return offerCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNotification *note = [NSNotification notificationWithName: OfferTableDidSelectOfferNotification object: [self offerForIndexPath:indexPath]];
    
    [[NSNotificationCenter defaultCenter] postNotification: note];
}

@end

NSString *OfferTableDidSelectOfferNotification = @"OfferTableDidSelectOfferNotification";