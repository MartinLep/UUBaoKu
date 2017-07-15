//
//  UUOrderListModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUOrderListModel : NSObject

@property(assign,nonatomic)NSInteger OrderType;
@property(assign,nonatomic)NSInteger OrderStatus;
@property(assign,nonatomic)NSInteger PayStatus;
@property(assign,nonatomic)NSInteger ShippingStatus;
@property(assign,nonatomic)NSInteger IsComment;
@property(assign,nonatomic)float ShippingFee;
@property(assign,nonatomic)float OrderAmount;
@property(assign,nonatomic)float PayOnLine;
@property(strong,nonatomic)NSString *OrderNO;
@property(strong,nonatomic)NSString *PayTime;
@property(strong,nonatomic)NSArray *OrderGoods;
@property(assign,nonatomic)NSInteger ShippingMode;
@property(strong,nonatomic)NSString *CreateTime;
@property(strong,nonatomic)NSString *ShippingTime;
@property(strong,nonatomic)NSString *Consignee;
@property(strong,nonatomic)NSString *ShipAddress;
@property(strong,nonatomic)NSString *ShippingCode;
@property(strong,nonatomic)NSString *ShippingName;
@property(strong,nonatomic)NSString *ReceiveTime;
@property(assign,nonatomic)float PayBalance;
@property(assign,nonatomic)float PayIntergral;
@property(assign,nonatomic)float GoodsProfit;
@property(assign,nonatomic)NSInteger PayType;
@property(assign,nonatomic)float GoodsAmount;
@property(assign,nonatomic)float GoodsTotalWeight;
@property(strong,nonatomic)NSString *RefoundId;
- (id)initWithDictionary:(NSDictionary *)dict;
@end
