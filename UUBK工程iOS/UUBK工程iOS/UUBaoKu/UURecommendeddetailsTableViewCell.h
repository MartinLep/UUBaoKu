//
//  UURecommendeddetailsTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/12/29.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UURecommendeddetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *words;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
