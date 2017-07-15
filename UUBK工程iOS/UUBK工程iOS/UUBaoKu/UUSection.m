//
//  UUSection.m
//  UUBaoKu
//
//  Created by admin on 16/10/18.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUSection.h"

@implementation UUSection
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat ScreenW = [UIScreen mainScreen].bounds.size.width;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,ScreenW, 100)];
        
        headerView.backgroundColor = [UIColor grayColor];
        
        
        
        
        
        
        
        [self addSubview:headerView];
        
        
    }
    return self;
}


@end
