//
//  UULinkTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/7.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UULinkTableViewCell.h"

@implementation UULinkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UULinkTableViewCell";
    UULinkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UULinkTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
