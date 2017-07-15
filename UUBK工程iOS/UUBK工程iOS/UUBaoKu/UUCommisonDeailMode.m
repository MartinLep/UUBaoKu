//
//  UUCommisonDeailMode.m
//  UUBaoKu
//
//  Created by dev on 17/2/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCommisonDeailMode.h"

@implementation UUCommisonDeailMode

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.Mobile = dict[@"Mobile"];
        self.CommisionAmcount = dict[@"CommissonAmount"];
        self.CommisionLevel = [dict[@"CommssionLevel"] integerValue];
        self.OrderNO = dict[@"OrderNO"];
        self.OrderCommssionTotalMoney = dict[@"OrderCommssionTotalMoney"];
        self.CommissonRatio = dict[@"CommissonRatio"];
        self.CreateTime = dict[@"CreateTime"];
        self.CommssionType = dict[@"CommssionType"];
        self.CommssionTypeName = dict[@"CommssionTypeName"];
        self.FaceImg = dict[@"FaceImg"];
    }
    return self;
}
@end
