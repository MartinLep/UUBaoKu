//
//  UUZoneGoodsModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUZoneGoodsModel : QZHModel
@property(nonatomic,strong)NSString *goodsDescription;
@property(nonatomic,strong)NSNumber *goodsId;
@property(nonatomic,strong)NSString *goodsName;
@property(nonatomic,strong)NSString *img;
@property(nonatomic,assign)BOOL third;
@property(nonatomic,strong)NSString *url;
@end
