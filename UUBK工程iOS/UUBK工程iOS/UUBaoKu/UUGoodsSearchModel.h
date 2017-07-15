//
//  UUGoodsSearchModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/25.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUGoodsSearchModel : NSObject

@property(assign,nonatomic)float MemberPrice;
@property(assign,nonatomic)float BuyPrice;
@property(assign,nonatomic)float MarketPrice;
@property(strong,nonatomic)NSString *GoodsTitle;
@property(strong,nonatomic)NSString *Url;
@property(strong,nonatomic)NSArray *Images;
@property(strong,nonatomic)NSString *GoodsName;
@property(strong,nonatomic)NSString *GoodsId;
@property(assign,nonatomic)NSInteger GoodsSaleNum;


- (id)initWithDictionary:(NSDictionary *)dict;
@end
