//
//  UU1PurchaseModel.m
//  UUBaoKu
//
//  Created by Lee Martin on 2017/7/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UU1PurchaseModel.h"

@implementation UU1PurchaseModel


- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    [self setValuesForKeysWithDictionary:dictionary];
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"UndefinedKey = %@",key);
}

@end
