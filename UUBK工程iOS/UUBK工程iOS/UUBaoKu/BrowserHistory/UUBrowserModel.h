//
//  UUBrowserModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUBrowserModel : NSObject
@property (strong,nonatomic)NSString *BuyPrice;
@property (strong,nonatomic)NSString *MemberPrice;
@property (strong,nonatomic)NSString *MarketPrice;
@property (strong,nonatomic)NSString *GoodsId;
@property (strong,nonatomic)NSString *GoodsName;
@property (strong,nonatomic)NSString *GoodsNum;
@property (strong,nonatomic)NSString *GoodsSaleNum;
@property (strong,nonatomic)NSString *GoodsTitle;
@property (strong,nonatomic)NSString *ImageUrl;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
