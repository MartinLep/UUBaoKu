//
//  UUpersonnalHeaderView.m
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//=====================个人相册========================

#import "UUpersonnalHeaderView.h"

#import "UIView+SDAutoLayout.h"
@implementation UUpersonnalHeaderView



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}
- (void)setup
{
    _backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:_backgroundImageView];
    
    _iconView = [UIImageView new];
    _iconView.image = [UIImage imageNamed:@"h6.png"];
    _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconView.layer.borderWidth = 3;
    [self addSubview:_iconView];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"GSD_iOS";
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_nameLabel];
    
    _iconView.sd_layout
    .widthIs(70)
    .heightIs(70)
    .rightSpaceToView(self, 20)
    .bottomSpaceToView(self, -20);
    
    
    _nameLabel.tag = 1000;
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    _nameLabel.sd_layout
    .rightSpaceToView(_iconView, 20)
    .bottomSpaceToView(_iconView, -35)
    .heightIs(20);
}

@end
