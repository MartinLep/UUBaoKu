//
//  UUFundingDetailsTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/12/9.
//  Copyright © 2016年 loongcrown. All rights reserved.
//========================资金明细=========================

#import "UUFundingDetailsTableViewCell.h"

@implementation UUFundingDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUFundingDetailsTableViewCell";
    UUFundingDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUFundingDetailsTableViewCell" owner:nil options:nil][0];
    }
    return cell;
}
@end
