//
//  uuMainButton.m
//  UUBaoKu
//
//  Created by admin on 16/10/19.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "uuMainButton.h"
#import "UIView+Ex.h"
@implementation uuMainButton

/*
 重写button的layoutSubviews方法，让button的图和字变成 上图下字
 */
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGPoint center=self.imageView.center;
    center.x=self.width/2;
    center.y=self.height/2-self.imageView.height/3;
    self.imageView.center=center;
    
    CGRect newFrame=[self titleLabel].frame;
    newFrame.origin.x=0;
    newFrame.origin.y=self.imageView.frame.origin.y + self.imageView.frame.size.height+10;
    newFrame.size.width=self.width;
    
    self.titleLabel.frame=newFrame;
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    
    if (self.enabled==NO) {
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
}

@end
