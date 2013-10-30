//
//  PhotoCell.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-17.
//

#import "PhotoCell.h"
@interface PhotoCell ()

@property (nonatomic,weak) IBOutlet UIImageView *photoImageView;

@end

@implementation PhotoCell
@synthesize image = _image;
@synthesize photoImageView = _photoImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

-(void)setImage:(UIImage *)image {
    if (_image != image) {
        _image = image;
        self.photoImageView.image = image;
        self.photoImageView.clipsToBounds = YES;
        self.photoImageView.layer.borderWidth = 3.0f;
        self.photoImageView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
        self.photoImageView.layer.cornerRadius = 8.0f;
        
       
    }
}

@end
