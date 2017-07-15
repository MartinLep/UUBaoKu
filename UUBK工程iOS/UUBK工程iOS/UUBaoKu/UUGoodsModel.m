//
//  UUGoodsModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGoodsModel.h"

@implementation UUGoodsModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.MemberPrice = dict[@"MemberPrice"];
        self.MarketPrice = dict[@"MarketPrice"];
        self.GoodsId = dict[@"GoodsId"];
        self.GoodsName = dict[@"GoodsName"];
        self.GoodsNum = dict[@"GoodsNum"];
        self.GoodsCode = dict[@"GoodsCode"];
        self.SKUID = dict[@"SKUID"];
        self.GoodsAttrName = dict[@"GoodsAttrName"];
        self.OriginalPrice = dict[@"OriginalPrice"];
        self.StrickePrice = dict[@"StrikePrice"];
        self.ImgUrl = dict[@"ImgUrl"];
        self.Status = dict[@"Status"];
        self.RefundId = dict[@"RefundId"]?dict[@"RefundId"]:@"0";
    }
    return self;
}
@end
