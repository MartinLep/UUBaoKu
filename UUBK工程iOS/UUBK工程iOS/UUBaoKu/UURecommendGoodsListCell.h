//
//  UURecommendGoodsListCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUSelectedGoodsModel.h"
@class UULinkGoodsModel;
@class UUAttentionGoodsModel;
@class UUBoughtGoodsModel;
@protocol RecommendGoodsDelegate <NSObject>
- (void)goToGoodsDetailWithIndexPath:(NSIndexPath *)indexPath;
@end
@interface UURecommendGoodsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsSale;
@property (weak, nonatomic) IBOutlet UIButton *goodsDetailBtn;
@property (weak, nonatomic) id<RecommendGoodsDelegate>delegate;
@property (nonatomic,strong) UUSelectedGoodsModel *model;
@property (nonatomic,strong) UULinkGoodsModel *linkModel;
@property (nonatomic,strong) UUBoughtGoodsModel *boughtModel;
@property (nonatomic,strong) UUAttentionGoodsModel *attentionModel;
@end
