//
//  UUMytreasureTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/12/1.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUMytreasureTableViewCell.h"

@implementation UUMytreasureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.Btn1.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    [self.Btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.Btn1.layer.masksToBounds = YES;
    self.Btn1.layer.cornerRadius = 2.5;
    
    self.Btn2.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    [self.Btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.Btn2.layer.masksToBounds = YES;
    self.Btn2.layer.cornerRadius = 2.5;
    
    
    self.Btn3.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    [self.Btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.Btn3.layer.masksToBounds = YES;
    self.Btn3.layer.cornerRadius = 2.5;
    
    self.Btn4.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    [self.Btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.Btn4.layer.masksToBounds = YES;
    self.Btn4.layer.cornerRadius = 2.5;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUMytreasureTableViewCell";
    UUMytreasureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUMytreasureTableViewCell" owner:nil options:nil][0];
    }
    return cell;
}
@end
