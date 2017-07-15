//
//  UUTodayBuyCollectionViewCell.m
//  UUBaoKu
//
//  Created by dev on 17/3/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUTodayBuyCollectionViewCell.h"

@implementation UUTodayBuyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.cutBtnA.layer setBorderColor:[UIColor redColor].CGColor];
    [self.cutBtnA.layer setBorderWidth:1];
    [self.cutBtnA.layer setCornerRadius:2.5];
    [self.cutBtnA.layer setMasksToBounds:YES];
    [self.cutBtnB.layer setCornerRadius:2.5];
    // Initialization code
}

@end
