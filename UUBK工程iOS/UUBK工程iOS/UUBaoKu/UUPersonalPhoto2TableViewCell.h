//
//  UUPersonalPhoto2TableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUPersonalPhoto2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgsView;


@property (weak, nonatomic) IBOutlet UITextView *content;


@property (weak, nonatomic) IBOutlet UILabel *imgsViewNum;

@property (weak, nonatomic) IBOutlet UILabel *createTimeFormat;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
