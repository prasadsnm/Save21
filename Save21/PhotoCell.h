//
//  PhotoCell.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-17.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell
@property (nonatomic,strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
