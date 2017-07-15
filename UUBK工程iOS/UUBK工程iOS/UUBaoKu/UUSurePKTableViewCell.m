//
//  UUSurePKTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/10/22.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUSurePKTableViewCell.h"

@implementation UUSurePKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.SurePkimageView.layer.cornerRadius = self.SurePkimageView.frame.size.width/2;
    self.SurePkimageView.layer.masksToBounds=YES;
    self.surePKBtn.layer.cornerRadius = 2.5;
    self.surePKBtn.layer.masksToBounds=YES;
    self.surePKBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    self.surePKBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    
    [self.surePKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.surePKBtn.layer.cornerRadius = 2.5;
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUSurePKTableViewCell";
    UUSurePKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUSurePKTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
