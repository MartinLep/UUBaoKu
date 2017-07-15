//
//  UURefundReasonModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UURefundReasonModel.h"

@implementation UURefundReasonModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.ID = dict[@"ID"];
        self.Label = dict[@"Label"];
        self.RefundType = [dict[@"RefundType"] integerValue];
    }
    return self;
}
@end
