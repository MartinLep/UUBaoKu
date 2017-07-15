//
//  UURecommendTypeCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UURecommendTypeCell.h"

@implementation UURecommendTypeCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.expRecommendBtn.layer.cornerRadius = 2.5;
    self.expRecommendBtn.layer.borderWidth = 1;
    self.feelingRecommendBtn.layer.cornerRadius = 2.5;
    self.feelingRecommendBtn.layer.borderWidth = 1;
    self.expRecommendBtn.layer.borderColor = UURED.CGColor;
    self.feelingRecommendBtn.layer.borderColor = UUGREY.CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)expRecommendAction:(UIButton *)sender {
    sender.selected = YES;
    self.feelingRecommendBtn.selected = NO;
    sender.layer.borderColor = UURED.CGColor;
    self.feelingRecommendBtn.layer.borderColor = UUGREY.CGColor;
    self.setRecommendType(@"1");
}

- (IBAction)feelingRecommendAction:(UIButton *)sender {
    sender.selected = YES;
    sender.layer.borderColor = UURED.CGColor;
    self.expRecommendBtn.selected = NO;
    self.expRecommendBtn.layer.borderColor = UUGREY.CGColor;
    self.setRecommendType(@"2");
}
@end
