//
//  UUPersonallTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUPersonallTableViewCell.h"

@implementation UUPersonallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"UUPersonallTableViewCell";
    UUPersonallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUPersonallTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
