//
//  UUGroupPurchaseTableViewCell.m
//  UUBaoKu
//
//  Created by dev on 17/3/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGroupPurchaseTableViewCell.h"
@implementation UUGroupPurchaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUGroupPurchaseTableViewCell";
    UUGroupPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUGroupPurchaseTableViewCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightBtn.layer.cornerRadius = 2.5;
        cell.rightBtn.layer.borderColor = UURED.CGColor;
        cell.rightBtn.layer.borderWidth = 0.5;
        cell.rightBtn.hidden = YES;
        cell.leftBtn.layer.cornerRadius = 2.5;
        cell.leftBtn.layer.borderColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1].CGColor;
        cell.leftBtn.layer.borderWidth = 0.5;
        cell.midBtn.layer.cornerRadius = 2.5;
        cell.midBtn.layer.borderColor = UUGREY.CGColor;
        cell.midBtn.layer.borderWidth = 0.5;
        cell.leftBtn.hidden = YES;
        cell.midBtn.hidden = YES;
        cell.secondNumLab.hidden = YES;
        cell.rughtLab4.hidden = YES;
    }
    return cell;
}

@end
