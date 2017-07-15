//
//  UUReturnGoodsModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUReturnGoodsModel.h"

@implementation UUReturnGoodsModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.RefoundId = dict[@"RefoundId"];
        self.GoodsID = dict[@"GoodsID"];
        self.Skuid = dict[@"Skuid"];
        self.Status = [dict[@"Status"] integerValue];
        self.OrderNO = dict[@"OrderNO"];
        self.GoodsTotalMoney = dict[@"GoodsTotalMoney"];
        self.RefundMoney = dict[@"RefundMoney"];
        self.GoodsName = dict[@"GoodsName"];
        self.ImageUrl = dict[@"ImageUrl"];
        self.RefundReason = dict[@"RefundReason"];
        self.GoodsAttrName = dict[@"GoodsAttrName"];
        self.OrderType = [dict[@"OrderType"] integerValue];
    }
    return self;
}
@end
