//
//  UU1PurchaseClassifyCell.m
//  UUBaoKu
//
//  Created by Lee Martin on 2017/7/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//


#import "UU1PurchaseClassifyCell.h"

@interface UU1PurchaseClassifyCell ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation UU1PurchaseClassifyCell

- (void)setModel:(UU1PurchaseModel *)model{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _imageView = [[UIImageView alloc] init];
    _imageView.layer.cornerRadius = 20;
    _imageView.layer.masksToBounds = true;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerX.mas_equalTo(self.contentView);
        make.top.equalTo(self.contentView);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = model.className;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.contentView.width, 20));
        make.top.mas_equalTo(_imageView.mas_bottom);
    }];
}

@end
