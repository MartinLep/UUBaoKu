//
//  UUSearchMemberCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/15.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSearchMemberCell.h"

@implementation UUSearchMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.descLab addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.descLab1 addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.descLab2 addGestureRecognizer:tap2];
    self.descLab.font = [UIFont systemFontOfSize:15*SCALE_WIDTH];
    self.descLab1.font = [UIFont systemFontOfSize:15*SCALE_WIDTH];
    self.descLab2.font = [UIFont systemFontOfSize:15*SCALE_WIDTH];
    self.numDescLab.font = [UIFont systemFontOfSize:15*SCALE_WIDTH];
    // Initialization code
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.delegate segmentSelectedWithTag:[tap view].tag];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)searchAction:(UIButton *)sender {
    [self.delegate searchActionWithMobile:self.userNameTF.text];
}
@end
