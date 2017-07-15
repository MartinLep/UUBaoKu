//
//  pwWidgetButton.m
//  ShowMo365
//
//  Created by zjf on 15/8/26.
//  Copyright (c) 2015年 zjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pwWidgetButton.h"
@implementation pwWidgetButton

- (void)initTitlePropety
{
    //[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//title color
}

- (void)initBorderPropety
{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    [self.layer setBorderColor:colorref];//边框颜色
}
+(id)buttonWithType:(UIButtonType)buttonType
{
    pwWidgetButton *pwBtn = [super buttonWithType:buttonType];
    return pwBtn;
}
-(id)init
{
    self=[super init];
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setPWType:(pwRelayoutButtonType)PWType{
    _PWType = PWType;
    if(PWType != pwRelayoutButtonTypeNomal) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}

//重写父类方法,改变标题和image的坐标
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    if (self.PWType == pwRelayoutButtonTypeLeft) {
        
        CGFloat x = contentRect.size.width - self.offset - self.imageSize.width ;
        CGFloat y =  contentRect.size.height -  self.imageSize.height;
        y = y/2;
        
        
        CGRect rect = CGRectMake(x,y,self.imageSize.width,self.imageSize.height);
        
        return rect;
    } else if (self.PWType == pwRelayoutButtonTypeBottom) {
        
        CGFloat x =  contentRect.size.width -  self.imageSize.width;
        
        CGFloat  y=   self.offset   ;
        
        x = x / 2;
        
        CGRect rect = CGRectMake(x,y,self.imageSize.width,self.imageSize.height);
        
        return rect;
        
    } else {
        return [super imageRectForContentRect:contentRect];
    }
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    if (self.PWType == pwRelayoutButtonTypeLeft) {
        
        return CGRectMake(0, 0, contentRect.size.width - self.offset - self.imageSize.width , contentRect.size.height);
        
        
    } else if (self.PWType == pwRelayoutButtonTypeBottom) {
        
        return CGRectMake(0,   self.offset + self.imageSize.height , contentRect.size.width , contentRect.size.height - self.offset - self.imageSize.height );
        
    } else {
        return [super titleRectForContentRect:contentRect];
    }
}

@end
