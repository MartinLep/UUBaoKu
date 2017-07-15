//
//  UUCommentTableViewCell.h
//  UUBaoKu
//
//  Created by dev on 17/3/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *GoodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *TimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *starImg1;
@property (weak, nonatomic) IBOutlet UIImageView *starImg2;
@property (weak, nonatomic) IBOutlet UIImageView *starImg3;
@property (weak, nonatomic) IBOutlet UIImageView *starImg4;
@property (weak, nonatomic) IBOutlet UIImageView *starImg5;
@property (weak, nonatomic) IBOutlet UILabel *ideaLab;
@property (weak, nonatomic) IBOutlet UIImageView *shareImg1;
@property (weak, nonatomic) IBOutlet UIImageView *shareImg2;
@property (weak, nonatomic) IBOutlet UIImageView *shareImg3;
@property (weak, nonatomic) IBOutlet UILabel *SpecNameLab;
@property (strong,nonatomic)NSArray *starImgArr;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
