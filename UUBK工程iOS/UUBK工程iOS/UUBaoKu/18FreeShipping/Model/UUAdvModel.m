//
//  UUAdvModel.m
//  UUBaoKu
//
//  Created by Martin on 2017/7/12.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUAdvModel.h"

@implementation UUAdvModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    [self setValuesForKeysWithDictionary:dictionary];
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"UUAdvModel UndefinedKey = %@",key);
}

@end
