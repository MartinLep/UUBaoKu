//
//  CustomTextField.m
//  UUBaoKu
//
//  Created by admin on 16/12/21.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

////控制清除按钮的位置
//-(CGRect)clearButtonRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(bounds.origin.x + bounds.size.width - 50, bounds.origin.y + bounds.size.height -20, 16, 16);
//}
//
//控制placeHolder的位置，左右缩20
//-(CGRect)placeholderRectForBounds:(CGRect)bounds
//{
//    
//    //return CGRectInset(bounds, 20, 0);
//    CGRect inset = CGRectMake(bounds.origin.x+100, bounds.origin.y, bounds.size.width -11.25, bounds.size.height);//更好理解些
//    return inset;
//}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 0,8.5);
//    CGRect inset = CGRectMake(bounds.origin.x+190, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
//    
//    return inset;
    
}
//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
      return CGRectInset(bounds, 0,8.5);
    
//    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width -10, bounds.size.height);
//    return inset;
}
////控制左视图位置
//- (CGRect)leftViewRectForBounds:(CGRect)bounds
//{
//    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width-250, bounds.size.height);
//    return inset;
//    //return CGRectInset(bounds,50,0);
//}
//
//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1].CGColor);
    [[UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1] setFill];
    
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:15]];
}


@end
