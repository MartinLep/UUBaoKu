//
//  OrderPayCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"

@interface OrderPayCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *otherPay;

@end
