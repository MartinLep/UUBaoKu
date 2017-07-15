//
//  UUCardImgViewCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCardImgViewCell.h"

@implementation UUCardImgViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.cardFace addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.cardCon addGestureRecognizer:tap2];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.delegate selectedCardImageWithTag:[tap view].tag];
}
@end
