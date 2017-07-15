//
//  UUWhoCanSeeGropTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 17/1/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUWhoCanSeeGropTableViewCell.h"

@implementation UUWhoCanSeeGropTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUWhoCanSeeGropTableViewCell";
    UUWhoCanSeeGropTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUWhoCanSeeGropTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}


@end
