//
//  UUPersonalPhoto2TableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUPersonalPhoto2TableViewCell.h"

@implementation UUPersonalPhoto2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"UUPersonalPhoto2TableViewCell";
    UUPersonalPhoto2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUPersonalPhoto2TableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}

@end
