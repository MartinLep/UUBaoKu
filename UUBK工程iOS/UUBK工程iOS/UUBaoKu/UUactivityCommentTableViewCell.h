//
//  UUactivityCommentTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 17/1/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUactivityCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIView *contentBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

-(void)userNameText:(NSString *)text;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
