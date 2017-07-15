//
//  UUMyLittleBeeCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/15.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMyLittleBeeCell.h"

@implementation UUMyLittleBeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLab.font = [UIFont systemFontOfSize:12*SCALE_WIDTH];
    self.gradeLevelLab.font = [UIFont systemFontOfSize:12*SCALE_WIDTH];
    self.typeLab.font = [UIFont systemFontOfSize:12*SCALE_WIDTH];
    self.disGradeLevelLab.font = [UIFont systemFontOfSize:12*SCALE_WIDTH];
    self.timeLab.font = [UIFont systemFontOfSize:12*SCALE_WIDTH];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
