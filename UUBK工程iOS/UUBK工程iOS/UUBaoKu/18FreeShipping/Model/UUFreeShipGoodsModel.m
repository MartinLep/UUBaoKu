//
// UUFreeShipGoodsModel.m
//  UUBaoKu
//
//  Created by Martin on 2017/7/12.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUFreeShipGoodsModel.h"

@implementation UUFreeShipGoodsModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    [self setValuesForKeysWithDictionary:dictionary];
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
     NSLog(@"UUGoodsModel UndefinedKey = %@",key);
}
@end
