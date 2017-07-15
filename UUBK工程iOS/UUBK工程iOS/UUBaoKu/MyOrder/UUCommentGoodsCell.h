//
//  UUCommentGoodsCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUGoodsModel.h"

@interface UUCommentGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsDesc;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (nonatomic,strong)UUGoodsModel *model;
@end
