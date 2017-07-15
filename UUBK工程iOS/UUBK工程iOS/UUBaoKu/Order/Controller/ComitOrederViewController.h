//
//  ComitOrederViewController.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUSkuidModel.h"
#import "UUGroupDetailModel.h"
#import "UUBQDetailModel.h"
#import "UULuckGroupModel.h"
typedef enum {
    OrderTypeBuyCar = 1,  //购物车下单
    OrderTypeSingle,      //单件商品下单(根据活动ID 区分活动与非活动)
    OrderTypeGroup        //团购下单(开团,入团)
}OrderType;

@interface ComitOrederViewController : UUBaseViewController
/**
 总价
 */
@property (nonatomic, copy) NSString *OrderAmount;

/**
   团购类型 1.开团 2,参团
 */
@property (nonatomic, copy) NSString *joinType;

/**
 活动ID
 */
@property (nonatomic, copy) NSString *promotionID;

/**
   单件商品下单数量 商品名
 */
@property (nonatomic, copy) NSString *SingleCount;
@property (nonatomic, copy) NSString *goosName;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, assign) OrderType orderType;
@property (nonatomic, copy) NSString *TeamBuyId;

/**
   立即下单model(活动/非活动)
 */
@property (strong,nonatomic)UUSkuidModel *SkuidModel;

/**
  团购model
 */
@property(strong,nonatomic)UUGroupDetailModel *groupModel;
@property(assign,nonatomic)NSInteger isBaoQiang;
@property(assign,nonatomic)NSInteger isLuck;
@property(strong,nonatomic)NSString *JoinId;
@property(strong,nonatomic)NSString *TeamId;
@property(strong,nonatomic)UUBQDetailModel *BQModel;
@property(strong,nonatomic)UULuckGroupModel *luckModel;
@property(strong,nonatomic)NSString *Cart;

/**
 立即购买 count
 */
@property (nonatomic, copy) NSString *count;
@end
