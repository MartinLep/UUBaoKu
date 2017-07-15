//
//  UUReturnDetailModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUReturnDetailModel : NSObject


@property(strong,nonatomic)NSString *GoodsID;
@property(assign,nonatomic)NSInteger Skuid;
@property(strong,nonatomic)NSString *GoodsName;
@property(strong,nonatomic)NSString *ImageUrl;
@property(strong,nonatomic)NSString *GoodsAttrName;
@property(assign,nonatomic)float StrikePrice;
@property(assign,nonatomic)NSInteger GoodsNum;
@property(strong,nonatomic)NSString *OrderNO;
@property(assign,nonatomic)float OrderTotalMoney;
@property(assign,nonatomic)float GoodsTotalMoney;
@property(strong,nonatomic)NSString *PayTime;
@property(assign,nonatomic)NSInteger ShippingFee;
@property(strong,nonatomic)NSString *RefoundId;
@property(assign,nonatomic)NSInteger RefoundType;
@property(assign,nonatomic)NSInteger Status;
@property(assign,nonatomic)float RefundMoney;
@property(strong,nonatomic)NSString *RefundReason;
@property(assign,nonatomic)NSInteger ReturnNum;
@property(strong,nonatomic)NSString *ExpressName;
@property(strong,nonatomic)NSString *ExpressNumber;
@property(strong,nonatomic)NSString *ExpressExplanation;
@property(assign,nonatomic)float ReturnIntegral;
@property(assign,nonatomic)float ReturnBalance;
@property(strong,nonatomic)NSString *ManagerMessage;
- (id)initWithDictionary:(NSDictionary *)dict;

@end
