//
//  UIButton+pwAddition.m
//  pwControls
//
//  Created by MartinLee on 17/2/6.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "UIButton+pwAddition.h"

@implementation UIButton (pwAddition)

+ (instancetype)pwButonText:(NSString *)title fontSize:(CGFloat)size normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor{
    return [self pwButonText:title fontSize:size normalColor:normalColor highlightedColor:highlightedColor backgroundImageName:nil];
}

+ (instancetype)pwButtonImage:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName{
    UIButton *button = [[self alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    NSString *imageNameHL = [imageName stringByAppendingString:@"_highlighted"];
    [button setImage:[UIImage imageNamed:imageNameHL] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    NSString *backgroundImageNameHL = [backgroundImageName stringByAppendingString:@"_highlighted"];
    [button setBackgroundImage:[UIImage imageNamed:backgroundImageNameHL] forState:UIControlStateHighlighted];
    [button sizeToFit];    
    return button;
}

+ (instancetype)pwButonText:(NSString *)title fontSize:(CGFloat)size normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor backgroundImageName:(NSString *)backgroundImageName{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    if(backgroundImageName != nil){
        [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
        NSString *backgroundImageNameHL = [backgroundImageName stringByAppendingString:@"_highlighted"];
        [button setBackgroundImage:[UIImage imageNamed:backgroundImageNameHL] forState:UIControlStateHighlighted];
    }
    [button sizeToFit];
    return button;
}


@end
