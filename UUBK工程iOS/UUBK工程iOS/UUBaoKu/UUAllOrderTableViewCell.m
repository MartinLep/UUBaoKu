//
//  UUAllOrderTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/12/8.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUAllOrderTableViewCell.h"

@implementation UUAllOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.deleteBtn.layer.masksToBounds= YES;
    self.deleteBtn.layer.cornerRadius = 2;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUAllOrderTableViewCell";
    UUAllOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUAllOrderTableViewCell" owner:nil options:nil][0];
    }
    return cell;
}
@end
