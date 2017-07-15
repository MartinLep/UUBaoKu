//
//  UUInitiatedPKTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/10/22.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUInitiatedPKTableViewCell.h"

@implementation UUInitiatedPKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lnitiatedPKImageView.layer.cornerRadius = self.lnitiatedPKImageView.frame.size.width/2;
    self.lnitiatedPKImageView.layer.masksToBounds=YES;
    self.backBtn.layer.cornerRadius = 2.5;
    self.backBtn.layer.masksToBounds=YES;
    self.backBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    
    [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backBtn.layer.cornerRadius = 2.5;
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUInitiatedPKTableViewCell";
    UUInitiatedPKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUInitiatedPKTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
