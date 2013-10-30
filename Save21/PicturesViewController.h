//
//  PicturesViewController.h
//  Save21
//
//  Created by Feiyang Chen on 13-10-16.
//

#import <UIKit/UIKit.h>

@interface PicturesViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;

@end
