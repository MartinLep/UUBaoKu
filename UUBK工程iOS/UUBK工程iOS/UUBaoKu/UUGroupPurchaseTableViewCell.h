//
//  UUGroupPurchaseTableViewCell.h
//  UUBaoKu
//
//  Created by dev on 17/3/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUGroupPurchaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *groupMemberLab;
@property (weak, nonatomic) IBOutlet UILabel *leaderNameLab;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *needMemberLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *EnjoinNumLab;
@property (weak, nonatomic) IBOutlet UILabel *secondNumLab;
@property (weak, nonatomic) IBOutlet UILabel *rughtLab4;
@property (weak, nonatomic) IBOutlet UIButton *midBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIImageView *prizeImg;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
