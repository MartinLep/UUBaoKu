//
//  UUfriendsMessageTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUfriendsMessageTableViewCell.h"

@implementation UUfriendsMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"UUfriendsMessageTableViewCell";
    UUfriendsMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUfriendsMessageTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
