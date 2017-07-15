//
//  UUSellWillTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/19.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UUHotArticles;
@interface UUSellWillTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentsNum;
@property (weak, nonatomic) IBOutlet UIButton *moreDataBtn;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UILabel *likeNum;

@property (weak, nonatomic) IBOutlet UIImageView *goodsimg1;
@property (weak, nonatomic) IBOutlet UIImageView *goodsimg2;
@property (weak, nonatomic) IBOutlet UIImageView *goodsimg3;


@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;



@property (weak, nonatomic) IBOutlet UILabel *sellWillRecommendType;

@property (weak, nonatomic) IBOutlet UILabel *words;

@property(nonatomic,strong)UUHotArticles *model;

@property(nonatomic,strong)NSArray *imageViews;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
