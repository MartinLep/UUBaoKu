//
//  UUAllOrderTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/12/8.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUAllOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
