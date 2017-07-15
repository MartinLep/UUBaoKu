//
//  UUeveryDayTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUeveryDayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *SubscriptLabel;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *stepNum;

@property (weak, nonatomic) IBOutlet UIImageView *iconimageVIew;


@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *numimage;
@property(assign,nonatomic)int userId;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
