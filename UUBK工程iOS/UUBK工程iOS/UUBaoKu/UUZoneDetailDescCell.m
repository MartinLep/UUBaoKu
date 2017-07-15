//
//  UUZoneDetailDescCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUZoneDetailDescCell.h"

@implementation UUZoneDetailDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)attentionAction:(UIButton *)sender {
    self.attentionAriticle();
}

- (IBAction)likeBtn:(UIButton *)sender {
    self.likeAriticle();
}
@end
