//
//  UUGoodsOrderTableViewCell.m
//  UUBaoKu
//
//  Created by dev on 17/3/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGoodsOrderTableViewCell.h"

@implementation UUGoodsOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUGoodsOrderTableViewCell";
    UUGoodsOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUGoodsOrderTableViewCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
