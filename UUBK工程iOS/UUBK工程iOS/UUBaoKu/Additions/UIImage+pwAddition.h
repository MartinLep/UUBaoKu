//
//  UIImage+pwAddition.h
//  pwControls
//
//  Created by MartinLee on 17/2/20.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImage (pwAddition)

- (UIImage *)pwImageWithColor:(UIColor *)color;

- (UIImage *)circleImage:(UIImage *)image withParam:(CGFloat)inset;

@end
