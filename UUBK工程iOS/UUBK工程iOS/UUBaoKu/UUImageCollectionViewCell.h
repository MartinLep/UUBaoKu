//
//  UUImageCollectionViewCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DelImageDelegate<NSObject>
- (void)delSelectedImageWithIndexPath:(NSIndexPath *)indexPath;
@end
@interface UUImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *delImageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) id<DelImageDelegate>delegate;
@end
