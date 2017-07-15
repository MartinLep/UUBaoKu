//
//  UUInterestListCollectionViewCell.m
//  UUBaoKu
//
//  Created by dev on 17/3/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUInterestListCollectionViewCell.h"
@implementation UUInterestListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.pictureV = [[UIImageView alloc]init];
        [self addSubview:self.pictureV];
        [self.pictureV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.height.and.width.mas_equalTo(60);
        }];
        
        self.titleLab = [[UILabel alloc]init];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.pictureV.mas_bottom).mas_offset(7.5);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(21);
        }];
        self.titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
        self.titleLab.textColor = UUBLACK;
        self.titleLab.textAlignment = NSTextAlignmentCenter;
//        self.backView = [[UIView alloc]init];
//        [self addSubview:_backView];
//        
//        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.mas_top);
//            make.right.mas_equalTo(self.mas_right);
//            make.height.and.width.mas_equalTo(20);
//        }];
//        _backView.backgroundColor = [UIColor whiteColor];
//        _backView.layer.cornerRadius = 10;
//        [_backView clipsToBounds];

        self.cover = [[UIView alloc]init];
        [self addSubview:self.cover];
        [self.cover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.height.and.width.mas_equalTo(60);
        }];
        self.cover.userInteractionEnabled = YES;
        self.cover.backgroundColor = [UIColor clearColor];
        self.cover.layer.cornerRadius = 60/2;
        self.cover.layer.borderWidth = 1.5;
        self.cover.layer.borderColor = [UIColor colorWithRed:234/255.0 green:73/255.0 blue:71/255.0 alpha:1].CGColor;
        self.selectIV = [[UIImageView alloc]init];
        
        [self addSubview:self.selectIV];
        [self.selectIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cover.mas_top);
            make.right.mas_equalTo(self.cover.mas_right);
            make.height.and.width.mas_equalTo(20);
        }];
        _selectIV.backgroundColor = [UIColor whiteColor];
        _selectIV.layer.cornerRadius = 10;
        [_selectIV clipsToBounds];
    }
    return self;
}
@end
