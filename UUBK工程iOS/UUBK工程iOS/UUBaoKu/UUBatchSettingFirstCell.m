//
//  UUBatchSettingFirstCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBatchSettingFirstCell.h"

@implementation UUBatchSettingFirstCell
- (IBAction)settingAction:(UIButton *)sender {
    [self.delegate batchSettingAction];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.settingBtn.layer.cornerRadius = 2.5;
    self.settingBtn.layer.borderWidth = 1;
    self.settingBtn.layer.borderColor = UUGREY.CGColor;
//    self.userInteractionEnabled = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
