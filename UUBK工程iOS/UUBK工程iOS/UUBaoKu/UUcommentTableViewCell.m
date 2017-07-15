//
//  UUcommentTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/5.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUcommentTableViewCell.h"

@implementation UUcommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.masksToBounds = YES;
    self.image.layer.cornerRadius = 20;
    [self.likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 30)];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUcommentTableViewCell";
    UUcommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell= (UUcommentTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:ID owner:self options:nil]  lastObject];
    }
    
    return cell;
}
@end
