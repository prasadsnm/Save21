//
//  SidebarCell2.m
//  ADVFlatUI
//
//  Created by Tope on 05/06/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "SidebarCell2.h"
#import <QuartzCore/QuartzCore.h>

@implementation SidebarCell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected){
        self.bgView.backgroundColor = self.mainColor;
    }
    else{
        self.bgView.backgroundColor = self.darkColor;
    }

    // Configure the view for the selected state
}

-(void)awakeFromNib{
    
    self.mainColor = [UIColor colorWithRed:255.0/255 green:88.0/255 blue:85.0/255 alpha:1.0f];
    self.darkColor = [UIColor colorWithRed:239.0/255 green:55.0/255 blue:52.0/255 alpha:1.0f];
    
    self.bgView.backgroundColor = self.mainColor;
    
    self.topSeparator.backgroundColor = [UIColor clearColor];
    self.bottomSeparator.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.2f];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:14.0f];
    
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.backgroundColor = self.mainColor;
    self.countLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:14.0f];
    
    self.countLabel.layer.cornerRadius = 3.0f;
}


@end
