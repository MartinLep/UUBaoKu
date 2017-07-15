//
//  UULogisticsModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UULogisticsModel.h"

@implementation UULogisticsModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.Msg = dict[@"Msg"];
        self.Time = dict[@"Time"];
    }
    return self;
}

@end
