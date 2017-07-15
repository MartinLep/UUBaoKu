//
//  UUtransferMessageTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/9.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUtransferMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *distributionLevelDesc;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;


@property(assign,nonatomic)int  userId;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
