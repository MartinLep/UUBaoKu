//
//  UUeveryDayTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUeveryDayTableViewCell.h"

@implementation UUeveryDayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconimageVIew.layer.masksToBounds = YES;
    self.iconimageVIew.layer.cornerRadius = self.iconimageVIew.width/2;
    
    self.SubscriptLabel.layer.masksToBounds = YES;
    self.SubscriptLabel.layer.cornerRadius = 7.5/2;
    self.SubscriptLabel.backgroundColor = [UIColor whiteColor];
    self.SubscriptLabel.textColor = [UIColor whiteColor];
    
    
    
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"UUeveryDayTableViewCell";
    UUeveryDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUeveryDayTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
