//
//  UUMessageGoods.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUMessageGoods : QZHModel
@property(nonatomic,strong)NSNumber *goodsId;
@property(nonatomic,strong)NSString *goodsName;
@property(nonatomic,assign)BOOL third;
@property(nonatomic,strong)NSString *url;
@end
