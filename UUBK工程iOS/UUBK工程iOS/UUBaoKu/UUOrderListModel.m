//
//  UUOrderListModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUOrderListModel.h"

@implementation UUOrderListModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.OrderType = [[self getStringWithObj:dict[@"OrderType"]] integerValue];
        self.OrderStatus = [[self getStringWithObj:dict[@"OrderStatus"]] integerValue];
        self.PayStatus = [[self getStringWithObj:dict[@"PayStatus"]]integerValue];
        self.ShippingStatus = [[self getStringWithObj:dict[@"ShippingStatus"]] integerValue];
        self.IsComment = [[self getStringWithObj:dict[@"IsComment"]] integerValue];
        self.ShippingFee = [[self getStringWithObj:dict[@"ShippingFee"]] floatValue];
        self.OrderAmount = [[self getStringWithObj:dict[@"OrderAmount"]] floatValue];
        self.PayOnLine = [[self getStringWithObj:dict[@"PayOnLine"]] floatValue];
        self.OrderNO = [self getStringWithObj:dict[@"OrderNO"]];
        self.PayTime = [self getStringWithObj:dict[@"PayTime"]];
        self.ShippingMode = [[self getStringWithObj:dict[@"ShippingMode"]]integerValue];
        self.CreateTime = [self getStringWithObj:dict[@"CreateTime"]];
        self.ShippingTime = [self getStringWithObj:dict[@"ShippingTime"]];
        self.Consignee = [self getStringWithObj:dict[@"Consignee"]];
        self.ShipAddress = [self getStringWithObj:dict[@"ShipAddress"]];
        self.ShippingCode = [self getStringWithObj:dict[@"ShippingCode"]];
        self.ShippingName = [self getStringWithObj:dict[@"ShippingName"]];
        self.ReceiveTime = [self getStringWithObj:dict[@"ReceiveTime"]];
        self.PayBalance = [[self getStringWithObj:dict[@"PayBalance"]] floatValue];
        self.PayIntergral = [[self getStringWithObj:dict[@"PayIntergral"]] floatValue];
        self.GoodsProfit = [[self getStringWithObj:dict[@"GoodsProfit"]] floatValue];
        self.PayType = [[self getStringWithObj:dict[@"PayType"]] integerValue];
        self.GoodsAmount = [[self getStringWithObj:dict[@"GoodsAmount"]] floatValue];
        self.GoodsTotalWeight = [[self getStringWithObj:dict[@"GoodsTotalWeight"]] floatValue];
        self.OrderGoods = dict[@"OrderGoods"];
        self.RefoundId = dict[@"RefoundId"]?dict[@"RefoundId"]:@"";
    }
    return self;
}

- (id)getStringWithObj:(id )Obj{
    if (![Obj isKindOfClass: [NSNull class]]) {
        return Obj;
    }else{
        return nil;
    }
}
@end
