//
//  UUAddImageCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddImageDelegate <NSObject>
- (void)clickAddImage;
- (void)delSelectedImageWithIndexPath:(NSIndexPath *)indexPath;
@end

@interface UUAddImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(strong,nonatomic)NSArray *imageArray;
@property(weak,nonatomic)id<AddImageDelegate>delegate;
@end
