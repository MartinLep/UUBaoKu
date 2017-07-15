//
//  UUTitleIconView.m
//  UUBaoKu
//
//  Created by admin on 16/10/18.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUTitleIconView.h"
#import "View+MASAdditions.h"
#define GrayColor [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1]
@interface UUTitleIconView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *icon;
@end
@implementation UUTitleIconView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self  = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLabel];
        
        _icon = [[UIImageView alloc]init];
        _icon.contentMode = UIViewContentModeCenter;
        [self addSubview:_icon];
        
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-10);;
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_icon.mas_bottom).offset(3);
            make.leading.trailing.equalTo(self);
            make.height.mas_equalTo(15);
        }];
    }
    return self ;
}

- (instancetype)initWithTitleLabel:(NSString *)titleLabel icon:(UIImage *)icon boder:(BOOL)boder{
    if (self = [super init]) {
        if (boder) {
            self.layer.borderColor = GrayColor.CGColor;
            self.layer.borderWidth = 0.5;
        }
        self.titleLabel.text = titleLabel;
        self.icon.image = icon;
        
    }
    return self;
}




@end
