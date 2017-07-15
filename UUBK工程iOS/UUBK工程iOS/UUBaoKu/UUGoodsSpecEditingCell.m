//
//  UUGoodsSpecEditingCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/22.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGoodsSpecEditingCell.h"


@implementation UUGoodsSpecEditingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setModel:(UUGoodsSpecModel *)model{
    _model = model;
    self.selectedBtn.selected = model.isSelected;
    self.descTextFiled.text = model.SpecName;
}


- (IBAction)selectedAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.delegate selectedSpecWithSender:sender];    
}
@end
