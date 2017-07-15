//
//  UUBrowserModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBrowserModel.h"

@implementation UUBrowserModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.BuyPrice = dict[@"BuyPrice"];
        self.MemberPrice = dict[@"MemberPrice"];
        self.MarketPrice = dict[@"MarketPrice"];
        self.GoodsId = dict[@"GoodsId"];
        self.GoodsName = dict[@"GoodsName"];
        self.GoodsNum = dict[@"GoodsNum"];
        self.GoodsSaleNum = dict[@"GoodsSaleNum"];
        self.GoodsTitle = dict[@"GoodsTitle"];
        self.ImageUrl = dict[@"ImageUrl"];
    }
    return self;
}
@end
