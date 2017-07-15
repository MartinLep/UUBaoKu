//
//  OrderlistCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"
typedef enum {
    CellTypeBuyCar = 1,//购物车下单
    CellTypeSingle,    //普通商品详情
    CellTypeGroup      //团购
}CellType;
@class BuyCarListModel;
@class UUSkuidModel;
@class UUGroupDetailModel;
@class UUBQDetailModel;
@class UULuckGroupModel;
@protocol OrderlistCellDelegate<NSObject>
- (void)backToBuyCar;
@end
@interface OrderlistCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *goBackCart;
@property (weak, nonatomic) IBOutlet UIImageView *GoodsIcon;
@property (weak, nonatomic) IBOutlet UILabel *oringinalPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetail;
@property (weak, nonatomic) IBOutlet UILabel *vipPrice;
@property (weak, nonatomic) IBOutlet UILabel *unit;
@property (weak, nonatomic) IBOutlet UILabel *goodType;
@property (nonatomic, assign) CellType cellType;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;

@property (nonatomic, copy) NSString *promotionID;
@property (nonatomic, strong) BuyCarListModel *buyCarlistModel;
/**
  活动/非活动
 */
@property (strong,nonatomic)UUSkuidModel *SkuidModel;
/**
 团购model
 */
@property(strong,nonatomic)UUGroupDetailModel *groupModel;
@property(strong,nonatomic)UUBQDetailModel *BQModel;
@property(strong,nonatomic)UULuckGroupModel *luckModel;

@property (nonatomic, weak) id<OrderlistCellDelegate>delegate;
@end
