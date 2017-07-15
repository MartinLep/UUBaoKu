//
//  UUMallGoodsDetailsModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/27.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMallGoodsDetailsModel.h"

@implementation UUMallGoodsDetailsModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.GoodsId = dict[@"GoodsId"];
        self.GoodsName = dict[@"GoodsName"];
        self.GoodsTitle = dict[@"GoodsTitle"];
        self.GoodsInfo = dict[@"GoodsInfo"];
        self.VipService = dict[@"VipService"];
        self.GoodsAttrs = dict[@"GoodsAttrs"];
        if (dict[@"ShareReduceInfo"]) {
            self.ShareReduceInfo = dict[@"ShareReduceInfo"];
        }
        self.Images = dict[@"Images"];
        if (dict[@"IsMyFavorite"]) {
            self.IsMyFavorite = [dict[@"IsMyFavorite"] integerValue];
        }
        if (dict[@"ProvinceName"]) {
            self.ProvinceName = dict[@"ProvinceName"];
            self.CityName = dict[@"CityName"];
            self.CountyName = dict[@"CountyName"];
            self.ProvinceId = dict[@"ProvinceId"];
            self.CityId = dict[@"CityId"];
            self.CountyId = dict[@"CountyId"];
        }
       
        self.EvaluationCount = [dict[@"EvaluationCount"]integerValue];
       
    }
    return self;
}
@end
