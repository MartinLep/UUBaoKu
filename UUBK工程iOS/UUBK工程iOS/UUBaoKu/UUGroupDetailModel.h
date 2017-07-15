//
//  UUGroupDetailModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUGroupDetailModel : NSObject

@property(strong,nonatomic)NSString *GoodsName;

@property(strong,nonatomic)NSString *GoodsTitle;

@property(strong,nonatomic)NSString *GoodsInfo;

@property(strong,nonatomic)NSArray *Images;

@property(assign,nonatomic)float MemberPrice;

@property(assign,nonatomic)float BuyPrice;
@property(assign,nonatomic)float TeamBuyPrice;

@property(strong,nonatomic)NSString *SKUID;

@property(strong,nonatomic)NSString *PromotionID;

@property(strong,nonatomic)NSString *EndDate;

@property(strong,nonatomic)NSString *StartDate;

@property(strong,nonatomic)NSArray *GroupPrice;

@property(strong,nonatomic)NSArray *OtherGroup;

@property(strong,nonatomic)NSString *VipService;

@property(strong,nonatomic)NSArray *GoodsAttrs;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
