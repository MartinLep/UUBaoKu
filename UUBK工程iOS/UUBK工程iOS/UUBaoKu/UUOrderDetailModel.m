//
//  UUOrderDetailModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/15.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUOrderDetailModel.h"

@implementation UUOrderDetailModel
- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.ShippingCode = [self getObjWithObj:dict[@"ShippingCode"]];
        self.ShippingName = [self getObjWithObj:dict[@"ShippingName"]];
        self.LogisticsLogo = dict[@"LogisticsLogo"];
        self.Logistics = dict[@"Logistics"];
    }
    return self;
}
- (id)getObjWithObj:(id)Obj{
    if (Obj == [NSNull null]) {
        return @"";
    }else{
        return Obj;
    }
}

@end
