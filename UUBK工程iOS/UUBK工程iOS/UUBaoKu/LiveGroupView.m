//
//  LiveGroupView.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/4/8.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "LiveGroupView.h"

@implementation LiveGroupView

- (void)awakeFromNib {
    [super awakeFromNib];
    kButtonRadius(self.groupSetBtn, 5);
}
#pragma mark -- 解散 离开群操作
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)setGroupClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setGroup)]) {
        [self.delegate setGroup];
    }
}

@end
