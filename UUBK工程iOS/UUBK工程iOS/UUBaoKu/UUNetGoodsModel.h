//
//  UUNetGoodsModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/7.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUNetGoodsModel : QZHModel

@property(nonatomic,strong)NSNumber *goodsId;
@property(nonatomic,strong)NSString *goodsName;
@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSNumber *price;
@property(nonatomic,strong)NSNumber *priceFormat;
@property(nonatomic,strong)NSNumber *salesNum;
@property(nonatomic,assign)BOOL third;
@property(nonatomic,strong)NSString *url;
@end
