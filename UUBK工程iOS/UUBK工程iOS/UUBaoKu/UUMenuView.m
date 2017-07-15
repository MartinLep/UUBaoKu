//
//  UUMenuView.m
//  UUBaoKu
//
//  Created by admin on 16/10/18.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUMenuView.h"

#import "UUTitleIconView.h"
@interface UUMenuView ()
@property (nonatomic, strong) NSArray *mens;
@end



@implementation UUMenuView


static const NSInteger DefaultRowNumbers = 4;

- (instancetype)initMenu:(NSArray <UUTitleIconView *>*)mens WithLine:(BOOL)line{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.mens = mens;
        for (UUTitleIconAction *title in mens) {
            
            
            UUTitleIconView *titleIconView = [[UUTitleIconView alloc]initWithTitleLabel:title.title icon:title.icon boder:line];
            titleIconView.tag = title.tag;
            titleIconView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleIconViewClick)];
            [titleIconView addGestureRecognizer:tap];
            [self addSubview:titleIconView];
        }
    }
    return self;
}

- (void)titleIconViewClick{
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width / DefaultRowNumbers;
    CGFloat height = self.bounds.size.height / (self.mens.count / DefaultRowNumbers);
    
    for (int i = 0; i < self.subviews.count; ++i) {
        UUTitleIconView *titleIconView = self.subviews[i];
        CGFloat viewX = (i % DefaultRowNumbers) * width;
        CGFloat viewY = (i / DefaultRowNumbers) * height;
        titleIconView.frame = CGRectMake(viewX, viewY, width, height);
    }
    
}

@end
