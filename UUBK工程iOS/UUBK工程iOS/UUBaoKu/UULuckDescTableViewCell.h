//
//  UULuckDescTableViewCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UULuckGroupModel.h"
@interface UULuckDescTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *privateCodeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderWidth;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLab;
@property (weak, nonatomic) IBOutlet UILabel *hasJoinedNumLab;
@property (weak, nonatomic) IBOutlet UILabel *needNumLab;
@property (strong, nonatomic) UULuckGroupModel *model;
@end
