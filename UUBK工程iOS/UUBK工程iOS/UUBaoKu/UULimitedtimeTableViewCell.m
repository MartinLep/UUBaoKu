//
//  UULimitedtimeTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/10/21.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UULimitedtimeTableViewCell.h"

@implementation UULimitedtimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.earncoins.layer setBorderColor:[UIColor redColor].CGColor];
    [self.earncoins.layer setBorderWidth:1];
    [self.earncoins.layer setMasksToBounds:YES];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UULimitedtimeTableViewCell";
    UULimitedtimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UULimitedtimeTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}@end
