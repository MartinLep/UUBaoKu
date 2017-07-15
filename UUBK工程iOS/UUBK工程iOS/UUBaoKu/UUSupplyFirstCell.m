//
//  UUSupplyFirstCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSupplyFirstCell.h"

@implementation UUSupplyFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.goodsStatus addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.checkStatus addGestureRecognizer:tap2];    // Initialization code
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.delegate selectedFirstSectionStatusWithTag:[tap view].tag];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
