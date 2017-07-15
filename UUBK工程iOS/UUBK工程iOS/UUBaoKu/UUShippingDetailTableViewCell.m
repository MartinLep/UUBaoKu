//
//  UUShippingDetailTableViewCell.m
//  UUBaoKu
//
//  Created by dev on 17/3/15.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUShippingDetailTableViewCell.h"

@implementation UUShippingDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUShippingDetailTableViewCell";
    UUShippingDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUShippingDetailTableViewCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}



@end
