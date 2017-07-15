//
//  UUReturnGoodsTableViewCell.h
//  UUBaoKu
//
//  Created by dev on 17/3/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUReturnGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsAttr;
@property (weak, nonatomic) IBOutlet UILabel *returnReasonLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *returnAmountLab;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsImgHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
