//
//  UIColor+pwAddition.m
//  pwControls
//
//  Created by MartinLee on 17/2/6.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "UIColor+pwAddition.h"

@implementation UIColor (pwAddition)

+ (instancetype)pwColorWithHex:(uint32_t)hex{
    uint8_t red = (hex & 0xff0000) >> 16;
    uint8_t green = (hex & 0x00ff00) >> 8;
    uint8_t blue = hex & 0x0000ff;
    return [UIColor pwColorWithRed:red green:green blue:blue];
}

+ (instancetype)pwRandomColor{
    return [UIColor pwColorWithRed:arc4random_uniform(256) green:arc4random_uniform(256) blue:arc4random_uniform(256)];
}

+ (instancetype)pwColorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f];
}
@end
