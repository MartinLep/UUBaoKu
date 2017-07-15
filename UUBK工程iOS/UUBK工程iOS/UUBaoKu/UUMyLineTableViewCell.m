//
//  UUMyLineTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/10/22.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUMyLineTableViewCell.h"

@implementation UUMyLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = self.icon.width/2;
    
    
 }
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUMyLineTableViewCell";
    UUMyLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUMyLineTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
