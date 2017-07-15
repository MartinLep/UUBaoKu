//
//  UUGroupDetailModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGroupDetailModel.h"

@implementation UUGroupDetailModel


- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.GoodsName = dict[@"GoodsName"];
        self.GoodsTitle = dict[@"GoodsTitle"];
        self.GoodsInfo = dict[@"GoodsInfo"];
        self.GoodsAttrs = dict[@"GoodsAttrs"];
        self.VipService = dict[@"VipService"];
        self.MemberPrice = [dict[@"MemberPrice"] floatValue];
        self.BuyPrice = [dict[@"BuyPrice"] floatValue];
        self.TeamBuyPrice = [dict[@"TeamBuyPrice"] floatValue];
        self.SKUID = dict[@"SKUID"];
        self.PromotionID = dict[@"PromotionID"];
        self.GroupPrice = dict[@"GroupPrice"];
        self.OtherGroup = dict[@"OtherGroup"];
        self.EndDate = dict[@"EndDate"];
        self.StartDate = dict[@"StartDate"];
        self.Images = dict[@"Images"];
    }
    return self;
}
@end
