//
//  UUSkuidModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/27.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSkuidModel.h"

@implementation UUSkuidModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.SKUID = dict[@"SKUID"];
        self.SpecInfo = dict[@"SpecInfo"];
        self.ImgUrl = dict[@"ImgUrl"];
        self.SpecShowName = dict[@"SpecShowName"];
        if (dict[@"PromotionPrice"]) {
            self.ActivePrice = [dict[@"PromotionPrice"] floatValue];
            self.OriginalPrice = [dict[@"OriginalPrice"] floatValue];
            self.LimitBuyNum = [dict[@"LimitBuyNum"] integerValue];
        }
        
        if (dict[@"BuyPrice"]) {
            self.BuyPrice = [dict[@"BuyPrice"] floatValue];
            self.MemberPrice = [dict[@"MemberPrice"] floatValue];
            self.MarketPrice =[dict[@"MarketPrice"] floatValue];
            self.FullGroupInfoList = dict[@"FullGroupInfoList"];
        }
        self.StockNum = [dict[@"StockNum"] integerValue];
        self.Weight = [dict[@"Weight"] floatValue];
        
        self.Postage = [dict[@"Postage"] floatValue];
    }
    return self;
}
@end
