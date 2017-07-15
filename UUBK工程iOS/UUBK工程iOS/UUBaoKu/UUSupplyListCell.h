//
//  UUSupplyListCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUSupplyGoodsModel.h"

@interface UUSupplyListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *supplyPrice;
@property (weak, nonatomic) IBOutlet UILabel *buyPrice;
@property (weak, nonatomic) IBOutlet UILabel *stockNum;
@property (weak, nonatomic) IBOutlet UILabel *goodsType;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *ckeckStatus;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *pullOffShelf;
@property (nonatomic,strong)UUSupplyGoodsModel *model;
@end
