//
//  UUBrowserHistoryTableViewCell.m
//  UUBaoKu
//
//  Created by dev on 17/3/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBrowserHistoryTableViewCell.h"

@implementation UUBrowserHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUBrowserHistoryTableViewCell";
    UUBrowserHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUBrowserHistoryTableViewCell" owner:nil options:nil][0];
    }
    return cell;
}

@end
