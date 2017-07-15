//
//  UUGroupModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUGroupModel : NSObject

@property(strong,nonatomic)NSString *EnjoinLuckyNum;
@property(strong,nonatomic)NSString *TeamBuyLeader;
@property(strong,nonatomic)NSString *FirstPrizeLuckyNum;
@property(strong,nonatomic)NSString *SecondPrizeLuckyNum;
@property(strong,nonatomic)NSString *ShippingFee;
@property(strong,nonatomic)NSString *OrderAmount;
@property(assign,nonatomic)BOOL IsFirstPrize;
@property(assign,nonatomic)BOOL IsSecondPrize;
@property(strong,nonatomic)NSString *EndDate;
@property(strong,nonatomic)NSString *JoinID;
@property(strong,nonatomic)NSString *IssueID;
@property(assign,nonatomic)NSInteger EnjoinNum;
@property(assign,nonatomic)NSInteger TotalNum;
@property(strong,nonatomic)NSString *GoodsName;
@property(strong,nonatomic)NSString *ImageUrl;
@property(strong,nonatomic)NSString *OrderNO;
@property(strong,nonatomic)NSString *ShippingCode;
@property(strong,nonatomic)NSString *ShippingName;
@property(assign,nonatomic)NSInteger TeamBuyType;
@property(assign,nonatomic)NSInteger ShippingStatus;
@property(assign,nonatomic)NSInteger TeamBuyStatus;
@property(assign,nonatomic)NSInteger OrderStatus;
@property(assign,nonatomic)NSInteger JoinType;
@property(strong,nonatomic)NSString *TeamBuyPrice;
@property(strong,nonatomic)NSString *PromotionPrice;
@property(strong,nonatomic)NSString *LuckyNum;
@property(strong,nonatomic)NSString *TuanSet;
@property(strong,nonatomic)NSString *IssueDate;
@property(strong,nonatomic)NSString *TuanID;
@property(strong,nonatomic)NSString *IsPrize;
@property(strong,nonatomic)NSString *ToBeAuditNum;
@property(assign,nonatomic)NSInteger Number;
- (id)initWithDictionary:(NSDictionary *)dict;

@end
