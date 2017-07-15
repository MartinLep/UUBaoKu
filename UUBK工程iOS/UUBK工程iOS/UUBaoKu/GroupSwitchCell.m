//
//  GroupSwitchCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "GroupSwitchCell.h"

@implementation GroupSwitchCell

#pragma mark -- 消息免打扰
- (IBAction)nodisturb:(id)sender {
    [self.delegate MsgNoDisturb:sender];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
