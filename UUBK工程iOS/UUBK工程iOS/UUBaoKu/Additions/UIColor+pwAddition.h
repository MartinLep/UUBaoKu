//
//  UIColor+pwAddition.h
//  pwControls
//
//  Created by MartinLee on 17/2/6.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (pwAddition)

/**
 使用 16 进制数字创建颜色，例如 0xFF0000 创建红色
 @param hex 16进制无符号32位整数
 @return 颜色
 */
+ (instancetype)pwColorWithHex:(uint32_t)hex;

/**
 生成随机颜色
 @return 颜色
 */
+ (instancetype)pwRandomColor;

/**
 使用RGB数值创建颜色
 */
+ (instancetype)pwColorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;

@end
