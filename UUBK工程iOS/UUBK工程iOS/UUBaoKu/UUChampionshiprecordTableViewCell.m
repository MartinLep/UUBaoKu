//
//  UUChampionshiprecordTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUChampionshiprecordTableViewCell.h"

@implementation UUChampionshiprecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUChampionshiprecordTableViewCell";
    UUChampionshiprecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUChampionshiprecordTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
