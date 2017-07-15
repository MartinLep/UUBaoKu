//
//  UUSelectedCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSelectedCell.h"

@implementation UUSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _maleBtn.selected = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)genderSelected:(UIButton *)sender {
    sender.selected = YES;
    if (sender.tag == 1) {
        _femaleBtn.selected = !_maleBtn.selected;
    }
    _maleBtn.selected = !_femaleBtn.selected;
    self.setGender([NSString stringWithFormat:@"%ld",sender.tag]);
}
@end
