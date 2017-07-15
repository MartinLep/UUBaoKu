//
//  UUCGAdditions.h
//
//  Created by 吴 天 on 12-8-17.
//  Copyright (c) 2012年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

extern void UUT_CGContextAddRoundRect(CGContextRef context, CGRect rect, CGFloat radius);
extern void UUT_CGContextClipToRoundRect(CGContextRef context, CGRect rect, CGFloat radius);

extern void UUT_CGContextFillRoundRect(CGContextRef context, CGRect rect, CGFloat radius);
extern void UUT_CGContextDrawLinearGradientBetweenPoints(CGContextRef context, CGPoint a, CGFloat color_a[4], CGPoint b, CGFloat color_b[4]);

extern CGContextRef UUT_UICreateGraphicsContext(CGSize size, BOOL isOpaque);
extern CGSize UUTCGBitmapContextGetPointSize(CGContextRef ctx);
