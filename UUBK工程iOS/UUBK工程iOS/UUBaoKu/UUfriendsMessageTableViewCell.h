//
//  UUfriendsMessageTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUfriendsMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *content;


@property (weak, nonatomic) IBOutlet UILabel *creatTimeFormat;

@property (weak, nonatomic) IBOutlet UITextView *comentContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgsFirst;



+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
