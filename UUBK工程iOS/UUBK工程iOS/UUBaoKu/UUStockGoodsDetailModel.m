//
//  UUStockGoodsDetailModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUStockGoodsDetailModel.h"

@implementation UUStockGoodsDetailModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.PayName = dict[@"PayName"];
        self.Money = dict[@"Money"];
        self.PayState = [dict[@"PayState"] integerValue];
        self.PayTime = dict[@"PayTime"];
        self.CallBackTime = dict[@"CallBackTime"];
    }
    return self;
}
@end
