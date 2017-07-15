//
//  UUReturnDetailModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUReturnDetailModel.h"

@implementation UUReturnDetailModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.GoodsID = dict[@"GoodsID"];
        self.Skuid = [dict[@"Skuid"] integerValue];
        self.ImageUrl = dict[@"ImageUrl"];
        self.GoodsName = dict[@"GoodsName"];
        self.GoodsAttrName = dict[@"GoodsAttrName"];
        self.StrikePrice = [dict[@"StrikePrice"] floatValue];
        self.GoodsNum = [dict[@"GoodsNum"] integerValue];
        self.OrderNO = dict[@"OrderNO"];
        self.OrderTotalMoney = [dict[@"OrderTotalMoney"] floatValue];
        self.GoodsTotalMoney = [dict[@"GoodsTotalMoney"] floatValue];
        self.PayTime = dict[@"PayTime"];
        self.ShippingFee = [dict[@"ShippingFee"] integerValue];
        self.RefoundId = dict[@"RefundId"];
        self.RefoundType = [dict[@"RefundType"] integerValue];
        self.Status = [dict[@"Status"] integerValue];
        self.RefundMoney = [dict[@"RefundMoney"] floatValue];
        self.RefundReason = dict[@"RefundReason"];
        self.ReturnNum = [dict[@"ReturnNum"] integerValue];
        self.ExpressName = dict[@"ExpressName"];
        self.ExpressNumber = dict[@"ExpressNumber"];
        self.ExpressExplanation = dict[@"ExpressExplanation"];
        self.ReturnIntegral = [dict[@"ReturnIntegral"] floatValue];
        self.ReturnBalance = [dict[@"ReturnBalance"] floatValue];
        self.ManagerMessage = dict[@"ManagerMessage"];
    }
    return self;
}
@end
