//
//  UUMyHeadView.m
//  UUBaoKu
//
//  Created by admin on 16/10/18.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUMyHeadView.h"

@implementation UUMyHeadView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat ScreenW = [UIScreen mainScreen].bounds.size.width;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,ScreenW, 200)];
        
        headerView.backgroundColor = [UIColor grayColor];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenW-100)/2, 40, 100, 100)];
        
        
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.layer.masksToBounds = YES;
        
        [imageView setImage:[UIImage imageNamed:@"h6"]];
        
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenW-100)/2+100, 40, 100, 30)];
        nameLabel.text = @"张小泉";
        
        [headerView addSubview:nameLabel];
        
        [headerView addSubview:imageView];
        
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, ScreenW, 100)];
        
        
        
        
        
        
        
        
        
        
        [self addSubview:headerView];
        
        
    }
    return self;
}


@end
