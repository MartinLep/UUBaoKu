//
//  UUSkuidModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/27.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUSkuidModel : NSObject

@property(strong,nonatomic)NSString *SKUID;
@property(strong,nonatomic)NSString *SpecInfo;
@property(strong,nonatomic)NSString *ImgUrl;
@property(strong,nonatomic)NSString *SpecShowName;
@property(assign,nonatomic)float BuyPrice;
@property(assign,nonatomic)float MemberPrice;
@property(assign,nonatomic)float MarketPrice;
@property(assign,nonatomic)float ActivePrice;
@property(assign,nonatomic)float OriginalPrice;
@property(assign,nonatomic)NSInteger StockNum;
@property(assign,nonatomic)float Weight;
@property(assign,nonatomic)NSInteger LimitBuyNum;
@property(assign,nonatomic)float Postage;
@property(strong,nonatomic)NSArray *FullGroupInfoList;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
