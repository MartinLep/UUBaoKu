//
//  UUBQDetailModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUBQDetailModel : QZHModel

@property(strong,nonatomic)NSString *GoodsName;
@property(strong,nonatomic)NSString *GoodsTitle;
@property(strong,nonatomic)NSString *GoodsInfo;
@property(strong,nonatomic)NSArray *Images;
@property(strong,nonatomic)NSNumber *MemberPrice;
@property(strong,nonatomic)NSNumber *BuyPrice;
@property(strong,nonatomic)NSNumber *TeamBuyPrice;
@property(strong,nonatomic)NSString *GoodsID;
@property(strong,nonatomic)NSString *ProductID;
@property(strong,nonatomic)NSString *SKUID;
@property(nonatomic,strong)NSNumber *TeamBuyNum;
@property(nonatomic,strong)NSNumber *TotalBuyNum;
@property(strong,nonatomic)NSString *EndDate;
@property(strong,nonatomic)NSString *StartDate;
@property(strong,nonatomic)NSArray *OtherGroup;
@property(strong,nonatomic)NSString *VipSerice;
@property(strong,nonatomic)NSArray *GoodsAttrs;
@end
