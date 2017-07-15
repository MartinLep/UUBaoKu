//
//  UUMytreasureTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/12/1.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUMytreasureTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *Btn1;
@property (weak, nonatomic) IBOutlet UIButton *Btn2;

@property (weak, nonatomic) IBOutlet UIButton *Btn3;

@property (weak, nonatomic) IBOutlet UIButton *Btn4;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
