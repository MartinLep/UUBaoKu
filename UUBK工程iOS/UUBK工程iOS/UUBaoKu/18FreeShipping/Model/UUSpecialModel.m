//
//  UUSpecialModel.m
//  UUBaoKu
//
//  Created by Martin on 2017/7/12.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSpecialModel.h"
#import "UUFreeShipGoodsModel.h"

@implementation UUSpecialModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    self.bannerImgUrl = dictionary[@"BannerImgUrl"];
    self.goodsList = [[NSMutableArray alloc] init];
    if(dictionary[@"GoodsList"]){
        NSArray *goodsArray = dictionary[@"GoodsList"];
        for (NSDictionary *dic in goodsArray) {
            UUFreeShipGoodsModel *model = [[UUFreeShipGoodsModel alloc] initWithDictionary:dic];
            [self.goodsList addObject:model];
        }
    }
    return self;
}

@end
