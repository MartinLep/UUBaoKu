//
//  UUtransferMessageTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/9.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUtransferMessageTableViewCell.h"

@implementation UUtransferMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = self.icon.width/2;
    self.selectedBtn.layer.masksToBounds = YES;
    self.selectedBtn.layer.cornerRadius = self.selectedBtn.width/2;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUtransferMessageTableViewCell";
    UUtransferMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUtransferMessageTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}

@end
