//
//  UUMallGoodsModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUMallGoodsModel : NSObject

@property(strong,nonatomic)NSString *SKUID;
@property(strong,nonatomic)NSString *PromotionID;
@property(assign,nonatomic)float PromotionPrice;
@property(assign,nonatomic)float OriginalPrice;
@property(assign,nonatomic)NSInteger TeamBuyNum;
@property(strong,nonatomic)NSString *GoodsTitle;
@property(strong,nonatomic)NSString *GoodsName;
@property(strong,nonatomic)NSString *Url;
@property(strong,nonatomic)NSString *GoodsId;
@property(assign,nonatomic)NSInteger GoodsSaleNum;
@property(strong,nonatomic)NSArray *Images;
@property(assign,nonatomic)NSInteger HelpBargainNum;
@property(assign,nonatomic)float BargainMoneyTotal;
@property(assign,nonatomic)float MemberPrice;
@property(assign,nonatomic)float BuyPrice;
@property(assign,nonatomic)float MarketPrice;
- (id)initWithDictionary:(NSDictionary *)dict;
@end
