//
//  ShopHome3TableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/10/19.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "ShopHome3TableViewCell.h"

@implementation ShopHome3TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ShopHomecel3";
    ShopHome3TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ShopHome3TableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
