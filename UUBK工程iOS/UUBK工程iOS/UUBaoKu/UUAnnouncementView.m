//
//  UUAnnouncementView.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUAnnouncementView.h"

@implementation UUAnnouncementView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)moreAnnouncementAction:(id)sender {
    [self.delegate goToMoreAnnounce];
}
@end
