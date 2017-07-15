//
//  UUStoreGoodsTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/12/9.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUStoreGoodsTableViewCell.h"

@implementation UUStoreGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUStoreGoodsTableViewCell";
    UUStoreGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUStoreGoodsTableViewCell" owner:nil options:nil][0];
    }
    return cell;
}
@end
