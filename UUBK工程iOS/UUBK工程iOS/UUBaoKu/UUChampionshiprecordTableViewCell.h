//
//  UUChampionshiprecordTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUChampionshiprecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *championstempLabel;
@property (weak, nonatomic) IBOutlet UILabel *championdata;

@property (weak, nonatomic) IBOutlet UILabel *rewardsLabel;



+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
