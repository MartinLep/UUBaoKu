//
//  UUShoppingProductsColleCollectionViewCell.m
//  UUBaoKu
//
//  Created by dev on 17/3/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUShoppingProductsColleCollectionViewCell.h"
@implementation UUShoppingProductsColleCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.pictureV = [[UIImageView alloc]init];
        [self addSubview:self.pictureV];
        [self.pictureV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.height.and.width.mas_equalTo(73);
        }];
//        self.pictureV.backgroundColor = BACKGROUNG_COLOR;
        self.pictureV.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLab = [[UILabel alloc]init];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.pictureV.mas_bottom).mas_offset(1.5);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(18.5);
        }];
        self.titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
        self.titleLab.textColor = UUGREY;
        self.titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
