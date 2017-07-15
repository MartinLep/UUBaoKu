//
//  UIImage+ImageColor.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/27.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UIImage+ImageColor.h"

@implementation UIImage (ImageColor)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
