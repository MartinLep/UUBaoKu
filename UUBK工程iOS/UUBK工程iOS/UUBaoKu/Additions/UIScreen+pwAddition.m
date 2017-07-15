//
//  UIScreen+pwAddition.m
//  pwControls
//
//  Created by MartinLee on 17/2/8.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "UIScreen+pwAddition.h"

@implementation UIScreen (pwAddition)

+ (CGFloat)pwScreenWidth{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)pwScreenHeight{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)pwScale{
    return [UIScreen mainScreen].scale;
}
@end
