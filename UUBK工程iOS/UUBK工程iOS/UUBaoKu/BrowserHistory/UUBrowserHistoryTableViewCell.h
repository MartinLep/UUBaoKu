//
//  UUBrowserHistoryTableViewCell.h
//  UUBaoKu
//
//  Created by dev on 17/3/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUBrowserHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodDescLab;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *orginPriceLab;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
