//
//  BuyCarCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/22.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"
@class BuyCarCell;
@class BuyCarListModel;
@protocol BuyCarCellDelegate <NSObject>

- (void)countChange:(UIButton *)sender Cell:(BuyCarCell *)cell;

@end
@interface BuyCarCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipPriceTitle;
@property (weak, nonatomic) IBOutlet UILabel *vipPrice;
@property (weak, nonatomic) IBOutlet UILabel *normalPrice;
@property (weak, nonatomic) IBOutlet UIView *deletLine;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

/**
  是否选中
 */

@property (nonatomic, assign) BOOL is_Selected;

@property (nonatomic, strong) BuyCarListModel *buyCarModel;
@property (nonatomic, strong) id<BuyCarCellDelegate>delegate;
@end
