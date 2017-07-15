//
//  UUProductListTableViewCell.m
//  UUBaoKu
//
//  Created by dev on 17/3/25.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUProductListTableViewCell.h"

@implementation UUProductListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUProductListTableViewCell";
    UUProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.goodsImage.contentMode = UIViewContentModeScaleAspectFit;
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUProductListTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}

@end
