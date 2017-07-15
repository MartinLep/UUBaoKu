//
//  UUStockMoneyDetailMode.m
//  UUBaoKu
//
//  Created by dev on 17/2/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUStockMoneyDetailMode.h"

@implementation UUStockMoneyDetailMode

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.IntegralType = dict[@"IntegralType"];
        self.IntegralNum = dict[@"IntegralNum"];
        self.CreateTime = dict[@"CreateTime"];
        self.IntegralTypeName = dict[@"IntegralTypeName"];
    }
    return self;
}
@end
