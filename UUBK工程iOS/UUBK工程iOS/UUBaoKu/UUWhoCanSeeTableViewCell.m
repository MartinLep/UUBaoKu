//
//  UUWhoCanSeeTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUWhoCanSeeTableViewCell.h"

@implementation UUWhoCanSeeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUWhoCanSeeTableViewCell";
    UUWhoCanSeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUWhoCanSeeTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
