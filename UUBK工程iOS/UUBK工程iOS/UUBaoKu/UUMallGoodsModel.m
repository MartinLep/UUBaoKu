//
//  UUMallGoodsModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMallGoodsModel.h"

@implementation UUMallGoodsModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        if (dict[@"SKUID"]) {
            self.SKUID = dict[@"SKUID"];
        }
        if (dict[@"PromotionID"]) {
            self.PromotionID = dict[@"PromotionID"];
        }
        
        if (dict[@"PromotionPrice"]) {
            self.PromotionPrice = [dict[@"PromotionPrice"] floatValue];

        }
        if (dict[@"OriginalPrice"]) {
            self.OriginalPrice = [dict[@"OriginalPrice"] floatValue];
        }
        
        if (dict[@"MemberPrice"]) {
            self.MemberPrice = [dict[@"MemberPrice"] floatValue];
        }
        if (dict[@"MarketPrice"]) {
            self.MarketPrice = [dict[@"MarketPrice"] floatValue];
        }
        
        if (dict[@"BuyPrice"]) {
            self.BuyPrice = [dict[@"BuyPrice"] floatValue];
            NSLog(@"采购价%@",dict[@"BuyPrice"]);
        }
        self.GoodsTitle = dict[@"GoodsTitle"];
        self.GoodsName = dict[@"GoodsName"];
        self.Url = dict[@"Url"];
        self.GoodsId = dict[@"GoodsId"];
        self.GoodsSaleNum = [dict[@"GoodsSaleNum"] integerValue];
        self.Images = dict[@"Images"];
        if (dict[@"TeamBuyNum"]) {
            self.TeamBuyNum = [dict[@"TeamBuyNum"] integerValue];
        }
        if (dict[@"HelpBargainNum"]) {
            self.HelpBargainNum = [dict[@"HelpBargainNum"] integerValue];
            
        }
        if (dict[@"BargainMoneyTotal"]) {
            self.BargainMoneyTotal = [dict[@"BargainMoneyTotal"] floatValue];
        }
    }
    return self;
}
@end

