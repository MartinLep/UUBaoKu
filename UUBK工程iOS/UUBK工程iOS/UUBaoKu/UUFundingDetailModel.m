//
//  UUFundingDetailModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/11.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUFundingDetailModel.h"

@implementation UUFundingDetailModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.MoneyTypeName = dict[@"MoneyTypeName"];
        self.OrderNo = dict[@"OrderNo"];
        self.FinanceMoney = [dict[@"FinanceMoney"] floatValue];
        self.CreateTime = dict[@"CreateTime"];
        self.Fee = [dict[@"Fee"] floatValue];
    }
    return self;
}
@end
