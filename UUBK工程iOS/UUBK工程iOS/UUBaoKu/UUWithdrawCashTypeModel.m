//
//  UUWithdrawCashTypeModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUWithdrawCashTypeModel.h"

@implementation UUWithdrawCashTypeModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.Desction = dict[@"Desction"];
        self.EnumName = dict[@"EnumName"];
        self.EnumValue = [dict[@"EnumValue"] integerValue];
    }
    return self;
}
@end
