//
//  UUWebViewController.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"
typedef enum {
    WebUrlHomeType = 0,
    WebUrlMarketType,
    WebUrlLoveCarType,
    WebUrlTripType,
    WebUrlMotherType,
    WebUrlGoodsDetailType,
    WebUrlTodyBuyType=9,
    WebUrlLimitType=11,
    WebUrlTenYuanType=12,
    WebUrlRushBuyType = 13,
    WebUrlSelectedType = 14,
    WebUrlSpecialType = 15
    
}WebUrlType;
@interface UUWebViewController : UUBaseViewController

@property(assign,nonatomic)WebUrlType webType;
@property(nonatomic, strong)NSString *url;
@end
