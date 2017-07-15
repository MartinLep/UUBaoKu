//
//  UUGoodsOrderTableViewCell.h
//  UUBaoKu
//
//  Created by dev on 17/3/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUGoodsOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *attrNameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab1;
@property (weak, nonatomic) IBOutlet UILabel *priceLab2;
@property (weak, nonatomic) IBOutlet UILabel *priceLab3;
@property (weak, nonatomic) IBOutlet UILabel *priceLab4;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
