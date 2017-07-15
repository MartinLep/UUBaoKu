//
//  UUOrderModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUOrderModel.h"

@implementation UUOrderModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.GoodsName = dict[@"GoodsName"];
        self.GoodsId = dict[@"GoodsId"];
        self.CreateTime = dict[@"CreateTime"];
        self.Star = dict[@"Star"];
        self.Idea = dict[@"Idea"];
        self.ShareImg = dict[@"ShareImg"];
        self.SpecName = dict[@"SpecName"];
        self.OrderNo = dict[@"OrderNo"];
    }
    return self;
}
@end
