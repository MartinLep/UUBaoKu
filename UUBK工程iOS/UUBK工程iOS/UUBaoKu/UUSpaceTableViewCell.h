//
//  UUSpaceTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/19.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UUZoneModel;
@class UUZoneGoodsModel;
@class UUZoneRecommendModel;
@interface UUSpaceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *creat_time;
@property (weak, nonatomic) IBOutlet UILabel *words;
@property (weak, nonatomic) IBOutlet UILabel *likeNum;
@property (weak, nonatomic) IBOutlet UILabel *commentsNum;
@property (weak, nonatomic) IBOutlet UIButton *MoreDataBtn;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *goodsDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsImgHeight;

@property (weak, nonatomic) IBOutlet UIImageView *usericon;
@property (weak, nonatomic) IBOutlet UILabel *username;

@property (weak, nonatomic) IBOutlet UILabel *spaceRecommendType;
@property (nonatomic,strong)UUZoneModel *zoneModel;
@property (nonatomic,strong)UUZoneGoodsModel *goodsModel;
@property (nonatomic,strong)UUZoneRecommendModel *recommendModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
