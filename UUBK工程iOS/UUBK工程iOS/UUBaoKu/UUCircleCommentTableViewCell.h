//
//  UUCircleCommentTableViewCell.h
//  UUBaoKu
//
//  Created by dev on 17/4/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UUZoneCommentModel;
@class UUCircleCommentTableViewCell;
@protocol ClickLikeDelegate <NSObject>

- (void)clickLikeWithCell:(UUCircleCommentTableViewCell *)cell andSender:(UIButton *)sender;

@end
@interface UUCircleCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (nonatomic,strong)UUZoneCommentModel *model;
@property (copy, nonatomic) NSString *articleId;
@property (weak, nonatomic) id<ClickLikeDelegate>delegate;
- (IBAction)likeBtnAction:(UIButton *)sender;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
