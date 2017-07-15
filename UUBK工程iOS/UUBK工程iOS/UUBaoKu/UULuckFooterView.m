//
//  UULuckFooterView.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UULuckFooterView.h"

@implementation UULuckFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"UULuckFooterView" owner:nil options:nil].lastObject;
        self.frame = frame;
    }
    return self;
}
- (IBAction)crateGroup:(id)sender {
}

- (IBAction)joinGroup:(id)sender {
}

- (IBAction)inviteFriend:(id)sender {
}
@end
