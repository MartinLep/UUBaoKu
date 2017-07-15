//
//  UUReleaseCommentCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUReleaseCommentCell.h"

@implementation UUReleaseCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.releaseBtn.layer.cornerRadius = 2.5;
    self.releaseBtn.layer.borderWidth = 1;
    self.releaseBtn.layer.borderColor = UURED.CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectAnonymous:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.setAnonymous(sender.selected);
}

- (IBAction)releaseComment:(UIButton *)sender {
    [self.delegate releaseComment];
}
@end
