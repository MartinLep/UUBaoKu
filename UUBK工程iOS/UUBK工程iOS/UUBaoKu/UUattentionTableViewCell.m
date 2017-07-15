//
//  UUattentionTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/7.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUattentionTableViewCell.h"

@implementation UUattentionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.price.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUattentionTableViewCell";
    UUattentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUattentionTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
