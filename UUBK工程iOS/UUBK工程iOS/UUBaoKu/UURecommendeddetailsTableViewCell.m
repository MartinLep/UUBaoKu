//
//  UURecommendeddetailsTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/12/29.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UURecommendeddetailsTableViewCell.h"

@implementation UURecommendeddetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = 20;
    
    
    
    
    
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UURecommendeddetailsTableViewCell";
    UURecommendeddetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UURecommendeddetailsTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}

@end
