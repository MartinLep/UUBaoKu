//
//  UUGoodsSearchModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/25.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGoodsSearchModel.h"

@implementation UUGoodsSearchModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.MemberPrice = [dict[@"MemberPrice"] floatValue];
        self.BuyPrice = [dict[@"BuyPrice"]floatValue];
        self.MarketPrice = [dict[@"MarketPrice"]floatValue];
        self.GoodsTitle = dict[@"GoodsTitle"];
        self.Url = dict[@"Url"];
        self.Images = dict[@"Images"];
        self.GoodsName = dict[@"GoodsName"];
        self.GoodsId = dict[@"GoodsId"];
        self.GoodsSaleNum = [dict[@"GoodsScaleNum"]integerValue];
        
        
    }
    return self;
}
@end
