//
//  UUGoodsCategoriesCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGoodsCategoriesCell.h"

@implementation UUGoodsCategoriesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.firstGradeLab addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.secondGradeLab addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.thirdGradeLab addGestureRecognizer:tap3];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.delegate selectedCategoryWithTag:[tap view].tag];
}

@end
