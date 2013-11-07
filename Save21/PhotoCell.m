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
@synthesize deleteButton = _deleteButton;

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

// INSERT CELL ANIMATION SNIPPET HERE
- (void)startQuivering
{
    CABasicAnimation *quiverAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    float startAngle = (-2) * M_PI/180.0;
    float stopAngle = -startAngle;
    quiverAnim.fromValue = [NSNumber numberWithFloat:startAngle];
    quiverAnim.toValue = [NSNumber numberWithFloat:3 * stopAngle];
    quiverAnim.autoreverses = YES;
    quiverAnim.duration = 0.2;
    quiverAnim.repeatCount = HUGE_VALF;
    float timeOffset = (float)(arc4random() % 100)/100 - 0.50;
    quiverAnim.timeOffset = timeOffset;
    CALayer *layer = self.layer;
    [layer addAnimation:quiverAnim forKey:@"quivering"];
}

- (void)stopQuivering
{
    CALayer *layer = self.layer;
    [layer removeAnimationForKey:@"quivering"];
}
@end
