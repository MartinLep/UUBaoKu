//
//  UUCommentScoreCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCommentScoreCell.h"

@implementation UUCommentScoreCell
- (IBAction)selectedScore:(UIButton *)sender {
    NSInteger star = sender.tag;
    NSArray *buttons = [NSArray arrayWithObjects:self.firstScore,self.secondScore,self.thirdScore,self.forthScore,self.fifthScore, nil];
    for (int i = 0; i < buttons.count; i++) {
        UIButton *btn = buttons[i];
        if (i < sender.tag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    self.setScore([NSString stringWithFormat:@"%ld",star]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
