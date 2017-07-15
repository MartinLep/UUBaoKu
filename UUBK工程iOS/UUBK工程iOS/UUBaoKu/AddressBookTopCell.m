//
//  AddressBookTopCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "AddressBookTopCell.h"

@implementation AddressBookTopCell
- (void)awakeFromNib {
    [super awakeFromNib];
    kImageViewRadius(self.ImgOne, self.ImgOne.width/2);
    kImageViewRadius(self.ImgTwo, self.ImgTwo.width/2);
    kButtonRadius(self.lookBtn, 3);
}

#pragma mark -- 点击查看
- (IBAction)lookUpHistory:(id)sender {
    [self.delegate lookUpMsg];
}
@end
