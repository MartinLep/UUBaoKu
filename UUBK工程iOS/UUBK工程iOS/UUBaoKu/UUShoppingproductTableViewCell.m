//
//  UUShoppingproductTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/18.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUShoppingproductTableViewCell.h"

@implementation UUShoppingproductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUShoppingproductTableViewCell";
    UUShoppingproductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUShoppingproductTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}

@end
