//
//  UUPersonallTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUPersonallTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *title;
@property (weak, nonatomic) IBOutlet UILabel *createTimeFormat;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
