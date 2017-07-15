//
//  UUMessageHomeTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/10/21.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UUMessageHomeModel.h"
@interface UUMessageHomeTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)NSString *messageHomeActiceid;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *MoreDataBtn;
//查看详情
@property (weak, nonatomic) IBOutlet UIView *commentBackView;

@property (weak, nonatomic) IBOutlet UIButton *DetailsBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBackViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgs;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
//@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *contentUsername;

@property (weak, nonatomic) IBOutlet UILabel *commentNum;
@property (weak, nonatomic) IBOutlet UILabel *likeNum;
@property(strong,nonatomic)NSArray  *commentsArray;
@property (weak, nonatomic) IBOutlet UILabel *recommendType;

@property (weak, nonatomic) IBOutlet UILabel *Words;

@property(strong,nonatomic)NSString *WordsStr;

//@property(strong,nonatomic)UILabel *Words;
@property(strong,nonatomic)NSArray *UUMessageHomeArray;

//模型
@property(nonatomic,strong)UUMessageHomeModel *MessageHomeModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
