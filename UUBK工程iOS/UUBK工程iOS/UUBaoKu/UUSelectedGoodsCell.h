//
//  UUSelectedGoodsCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/7/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UULinkGoodsModel;
@class UUAttentionGoodsModel;
@class UUBoughtGoodsModel;
@interface UUSelectedGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (nonatomic, strong) UULinkGoodsModel *linkModel;
@property (nonatomic, strong) UUAttentionGoodsModel *attentionModel;
@property (nonatomic, strong) UUBoughtGoodsModel *boughtModel;
@end
