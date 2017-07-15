//
//  UUPersonal2TableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUPersonal2TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UIImageView *imagsView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeFormat;



+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
