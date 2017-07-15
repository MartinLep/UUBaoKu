//
//  UIButton+pwAddition.h
//  pwControls
//
//  Created by MartinLee on 17/2/6.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (pwAddition)

/**
 创建文本按钮
 @param title            标题文字
 @param size             字体大小
 @param normalColor      默认颜色
 @param highlightedColor 高亮颜色
 
 @return UIButton
 */

+ (instancetype)pwButonText:(NSString *)title fontSize:(CGFloat)size normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor;

/**
 创建文本按钮
 
 @param title               标题文字
 @param size            字体大小
 @param normalColor         默认颜色
 @param highlightedColor    高亮颜色
 @param backgroundImageName 背景图像名称
 
 @return UIButton
 */

+ (instancetype)pwButonText:(NSString *)title fontSize:(CGFloat)size normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor backgroundImageName:(NSString *)backgroundImageName;


/**
 创建图像按钮
 
 @param imageName           图像名称
 @param backgroundImageName 背景图像名称
 
 @return UIButton
 */

+ (instancetype)pwButtonImage:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName;
@end
