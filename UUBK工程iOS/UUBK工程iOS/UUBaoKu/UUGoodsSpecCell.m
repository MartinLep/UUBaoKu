//
//  UUGoodsSpecCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGoodsSpecCell.h"


@implementation UUGoodsSpecCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editingSpecAction:(UIButton *)sender {
    [self.delegate editingGoodsAttr];
}
@end
