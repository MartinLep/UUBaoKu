//
//  UUMoreBarButton.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/25.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMoreBarButton.h"

@implementation UUMoreBarButton

/*
 重写button的layoutSubviews方法，让button的图和字变成 上图下字
 */
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGPoint center=self.imageView.center;
    center.x=self.width/2;
    center.y=self.height/2-self.imageView.height/5;
    self.imageView.center=center;
    
    CGRect newFrame=[self titleLabel].frame;
    newFrame.origin.x=0;
    newFrame.origin.y=self.imageView.frame.origin.y + self.imageView.frame.size.height+4;
    newFrame.size.width=self.width;
    
    self.titleLabel.frame=newFrame;
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    [self setTitleColor:UUGREY forState:UIControlStateNormal];
    if (self.enabled==NO) {
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
}

@end
