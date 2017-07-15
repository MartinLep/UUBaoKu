//
//  GoodCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllBuyGoodsCellDelegate<NSObject>
- (void)goToEarnKubiWithIndexPath:(NSIndexPath *)indexPath;
@end
@class GuesslikeModel;
@class UUMallGoodsModel;
@interface GoodCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UILabel *vipPrice;
@property (weak, nonatomic) IBOutlet UIButton *makeCoinBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeightConstraint;
@property (weak, nonatomic) id<AllBuyGoodsCellDelegate>delegate;
@property (nonatomic, strong) GuesslikeModel *guessModel;
@property (nonatomic, strong) UUMallGoodsModel *allBuyModel;
@end
