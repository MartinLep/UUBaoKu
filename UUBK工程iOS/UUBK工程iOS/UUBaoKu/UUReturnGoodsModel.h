//
//  UUReturnGoodsModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUReturnGoodsModel : NSObject

@property(strong,nonatomic)NSString *RefoundId;
@property(strong,nonatomic)NSString *GoodsID;
@property(strong,nonatomic)NSString *Skuid;
@property(assign,nonatomic)NSInteger Status;
@property(strong,nonatomic)NSString *OrderNO;
@property(strong,nonatomic)NSString *GoodsTotalMoney;
@property(strong,nonatomic)NSString *RefundMoney;
@property(strong,nonatomic)NSString *GoodsName;
@property(strong,nonatomic)NSString *ImageUrl;
@property(strong,nonatomic)NSString *RefundReason;
@property(strong,nonatomic)NSString *GoodsAttrName;
@property(assign,nonatomic)NSInteger OrderType;
- (id)initWithDictionary:(NSDictionary *)dict;
@end
