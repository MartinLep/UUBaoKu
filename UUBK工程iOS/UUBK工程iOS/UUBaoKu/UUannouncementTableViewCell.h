//
//  UUannouncementTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/10/21.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUannouncementTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeFormat;
@property(strong,nonatomic)NSString *id;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
