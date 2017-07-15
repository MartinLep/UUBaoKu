//
//  ComitOrderTopView.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "ComitOrderTopView.h"

@implementation ComitOrderTopView
- (IBAction)choiceDeliveryMode:(id)sender {
    [self.delegate deliveryModeWithBtn:sender];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
