//
//  OrderBotttomView.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "OrderBotttomView.h"

@implementation OrderBotttomView
- (IBAction)ConfirmOrderClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(ComfirmOrder)]) {
        [self.delegate ComfirmOrder];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
