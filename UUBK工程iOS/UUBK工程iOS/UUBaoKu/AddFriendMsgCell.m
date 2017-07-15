//
//  AddFriendMsgCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "AddFriendMsgCell.h"

@implementation AddFriendMsgCell
- (void)awakeFromNib {
    [super awakeFromNib];
    kButtonRadius(self.msgStateBtn, 3);
    kButtonRadius(self.accepBtn, 3);
    kImageViewRadius(self.userIcon, self.userIcon.width/2);
}

- (void)setAddMsgModel:(AddMsgModel *)addMsgModel {
    _addMsgModel = addMsgModel;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:addMsgModel.userIcon] placeholderImage:[UIImage imageNamed:@"群头像"]];
    self.UserName.text = addMsgModel.userName;
    self.descr.text = addMsgModel.content;
    if ([addMsgModel.status isEqualToString:@"1"]) {
        self.accepBtn.hidden = YES;
        [self.msgStateBtn setTitle:@"已添加" forState:UIControlStateNormal];
        self.msgStateBtn.backgroundColor = [UIColor lightGrayColor];
        self.msgStateBtn.enabled = NO;
    } else if ([addMsgModel.status isEqualToString:@"2"]) {
        self.accepBtn.hidden = YES;
        [self.msgStateBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
        self.msgStateBtn.backgroundColor = [UIColor lightGrayColor];
        self.msgStateBtn.enabled = NO;
    } else {
        self.accepBtn.hidden = NO;
        self.msgStateBtn.enabled = YES;
        [self.accepBtn setTitle:@"同意" forState:UIControlStateNormal];
        [self.msgStateBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    }
    
}
#pragma mark -- 好友信息状态
- (IBAction)Friend:(id)sender {
    [self.delegate ChangeStateWithButton:sender Cell:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
