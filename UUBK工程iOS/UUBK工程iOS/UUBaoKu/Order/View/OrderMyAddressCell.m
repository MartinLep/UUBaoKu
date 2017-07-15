//
//  OrderMyAddressCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "OrderMyAddressCell.h"

@implementation OrderMyAddressCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.text = @"";
    self.addressLabel.text = @"";
    self.addAddresss.hidden = YES;
}

- (IBAction)selectAddress:(id)sender {
    if (sender == self.selectedBtn) {//选则地址方式
        [self.delegate addressFunctionWithTag:@"1" Cell:self Button:sender];
    } else if (sender == self.addAddresss) {//新增地址
        [self.delegate addressFunctionWithTag:@"2" Cell:self Button:sender];
    } else if (sender == self.enterAddresslistBtn) {//进入地址列表
        [self.delegate addressFunctionWithTag:@"3" Cell:self Button:sender];
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
