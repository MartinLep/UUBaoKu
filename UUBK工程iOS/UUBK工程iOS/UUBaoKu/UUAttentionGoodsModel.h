//
//  UUAttentionGoodsModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/7/3.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUAttentionGoodsModel : QZHModel
@property(nonatomic,strong)NSNumber *BuyPrice;
@property(nonatomic,strong)NSNumber *MemberPrice;
@property(nonatomic,strong)NSNumber *GoodsId;
@property(nonatomic,strong)NSString *GoodsName;
@property(nonatomic,strong)NSNumber *GoodsNum;
@property(nonatomic,strong)NSNumber *GoodsSaleNum;
@property(nonatomic,strong)NSString *GoodsTitle;
@property(nonatomic,strong)NSString *ImageUrl;
@end
