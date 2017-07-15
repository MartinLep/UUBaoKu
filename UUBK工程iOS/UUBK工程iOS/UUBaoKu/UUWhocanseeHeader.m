//
//  UUWhocanseeHeader.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUWhocanseeHeader.h"

@implementation UUWhocanseeHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"UUWhocanseeHeader" owner:nil options:nil].lastObject;
        self.frame = frame;
    }
    return self;
}

- (IBAction)statusChangeAction:(UIButton *)sender {
    sender.selected = YES;
    [self.delegate selectedStatusWithIndex:sender.indexPath.section];
}
@end
