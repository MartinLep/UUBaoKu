//
//  UUaddaimsTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/12/21.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUaddaimsTableViewCell.h"

@implementation UUaddaimsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addAimsicon.layer.masksToBounds = YES;
    self.addAimsicon.layer.cornerRadius = 16;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUaddaimsTableViewCell";
    UUaddaimsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUaddaimsTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}


@end
