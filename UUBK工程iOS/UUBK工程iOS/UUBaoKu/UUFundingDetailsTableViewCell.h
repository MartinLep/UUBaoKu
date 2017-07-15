//
//  UUFundingDetailsTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/12/9.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUFundingDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *MoneyTypeNameLab;
@property (weak, nonatomic) IBOutlet UILabel *OrderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *FinanceMoney;
@property (weak, nonatomic) IBOutlet UILabel *CreateTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *FeeLab;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
