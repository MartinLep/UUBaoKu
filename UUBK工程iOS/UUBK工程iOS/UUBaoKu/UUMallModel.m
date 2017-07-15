//
//  UUMallModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMallModel.h"

@implementation UUMallModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.LimitTimeBuy = dict[@"LimitTimeBuy"];
        self.Slide = dict[@"Slide"];
        self.SelectGroup = dict[@"SelectGroup"];
        self.SpecialGroup = dict[@"SpecialGroup"];
        self.TodayPrice = dict[@"TodayPrice"];
        self.TenFreeShip = dict[@"TenFreeShip"];
        self.RushBuy = dict[@"RushBuy"];
        self.Bulletin = dict[@"Bulletin"];
    }
    return self;
}
@end
