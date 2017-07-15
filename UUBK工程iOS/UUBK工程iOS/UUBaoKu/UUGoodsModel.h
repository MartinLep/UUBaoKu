//
//  UUGoodsModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUGoodsModel : NSObject
@property (strong,nonatomic)NSString *GoodsId;
@property (strong,nonatomic)NSString *GoodsName;
@property (strong,nonatomic)NSString *GoodsCode;
@property (strong,nonatomic)NSString *SKUID;
@property (strong,nonatomic)NSString *GoodsAttrName;
@property (strong,nonatomic)NSString *MemberPrice;
@property (strong,nonatomic)NSString *MarketPrice;
@property (strong,nonatomic)NSString *OriginalPrice;
@property (strong,nonatomic)NSString *StrickePrice;
@property (strong,nonatomic)NSNumber *GoodsNum;
@property (strong,nonatomic)NSString *ImgUrl;
@property (strong,nonatomic)NSString *Status;
@property (strong,nonatomic)NSString *RefundId;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
