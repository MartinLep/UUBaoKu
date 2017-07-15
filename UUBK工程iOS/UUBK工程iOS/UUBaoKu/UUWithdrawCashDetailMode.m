//
//  UUWithdrawCashDetailMode.m
//  UUBaoKu
//
//  Created by dev on 17/2/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUWithdrawCashDetailMode.h"

@implementation UUWithdrawCashDetailMode

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.BankCardID = dict[@"BankCardID"];
        self.WithDrawMoney = dict[@"WithDrawMoney"];
        self.WithDrawType = [dict[@"WithdrawType"] integerValue];
        self.WithDrawTypeName = dict[@"WithDrawTypeName"];
        self.CheckStatu = [dict[@"CheckStatu"] integerValue];
        self.CreateTime = dict[@"CreateTime"];
        self.CheckTime = dict[@"CheckTime"];
        self.BankName = dict[@"BankName"];
        self.ImgUrl = dict[@"ImgUrl"];
//        self.TotalCount = dict[@"totalCount"]
    }
    return self;
}
@end
