//
//  UUBQGoodsDescCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUBQDetailModel.h"

@interface UUBQGoodsDescCell : UITableViewCell
@property(strong,nonatomic)UUBQDetailModel *model;
@property (weak, nonatomic) IBOutlet UILabel *howMuchTeamLab;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *orginalPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *joinedTeamLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLab;

@end
