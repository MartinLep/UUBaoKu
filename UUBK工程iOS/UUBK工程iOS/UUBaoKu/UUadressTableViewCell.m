//
//  UUadressTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/18.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUadressTableViewCell.h"

@implementation UUadressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUadressTableViewCell";
    UUadressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUadressTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}

@end
