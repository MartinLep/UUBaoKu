//
//  UUSelectedGoodsModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUSelectedGoodsModel : QZHModel
@property(nonatomic,strong)NSString *GoodsUrl;
@property(nonatomic,strong)NSString *ImageUrl;
@property(nonatomic,strong)NSString *GoodsId;
@property(nonatomic,strong)NSString *GoodsSaleNum;
@property(nonatomic,strong)NSString *GoodsName;
@property(nonatomic,strong)NSNumber *BuyPrice;
@property(nonatomic,strong)NSNumber *GoodsPrice;
@property(nonatomic,strong)NSNumber *CostPrice;
@end
