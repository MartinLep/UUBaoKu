//
//  UUcommentTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/5.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUcommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *usericon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *createTimeFormat;
@property (weak, nonatomic) IBOutlet UILabel *likeNum;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property(assign,nonatomic)int id;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
