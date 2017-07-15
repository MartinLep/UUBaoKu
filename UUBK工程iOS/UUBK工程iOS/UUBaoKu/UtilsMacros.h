//
//  UtilsMacros.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#ifndef UtilsMacros_h
#define UtilsMacros_h
//字符串转换
#define KString(string) [NSString stringWithFormat:@"%@", string]
#define kAString(a,b) [a stringByAppendingString:b]
//RGB
#define kRGB(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// View 圆角和加边框
#define kViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define kViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

// ImageView 圆角
#define kImageViewRadius(ImageView, Radius)\
\
[ImageView.layer setCornerRadius:(Radius)];\
[ImageView.layer setMasksToBounds:YES]
//ImageView 圆角 边框
#define kImageBorderRadius(ImageView, Radius, Width, Color)\
\
[ImageView.layer setCornerRadius:(Radius)];\
[ImageView.layer setMasksToBounds:YES];\
[ImageView.layer setBorderWidth:(Width)];\
[ImageView.layer setBorderColor:[Color CGColor]]

// button 圆角
#define kButtonRadius(button, Radius)\
\
[button.layer setCornerRadius:(Radius)];\
[button.layer setMasksToBounds:YES]

// button 圆角 边框
#define kButtonBorderRadius(Button, Radius, Width, Color)\
\
[Button.layer setCornerRadius:(Radius)];\
[Button.layer setMasksToBounds:YES];\
[Button.layer setBorderWidth:(Width)];\
[Button.layer setBorderColor:[Color CGColor]]

#endif /* UtilsMacros_h */
