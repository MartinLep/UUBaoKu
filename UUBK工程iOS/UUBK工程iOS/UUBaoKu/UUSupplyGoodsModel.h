//
//  UUSupplyGoodsModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUSupplyGoodsModel : QZHModel

@property(nonatomic,strong)NSNumber *Id;
@property(nonatomic,strong)NSString *GoodsName;
@property(nonatomic,strong)NSNumber *PurchasePrice;
@property(nonatomic,strong)NSNumber *DistributionPrice;
@property(nonatomic,strong)NSNumber *StockNum;
@property(nonatomic,strong)NSString *GoodsSheilves;
@property(nonatomic,strong)NSString *Status;
@property(nonatomic,strong)NSString *OnShelfTime;
@property(nonatomic,strong)NSString *ImgUrl;
@end
