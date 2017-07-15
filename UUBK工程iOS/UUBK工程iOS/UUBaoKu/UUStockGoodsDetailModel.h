//
//  UUStockGoodsDetailModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUStockGoodsDetailModel : NSObject

@property(strong,nonatomic)NSString *PayName;

@property(strong,nonatomic)NSNumber *Money;

@property(assign,nonatomic)NSInteger PayState;

@property(strong,nonatomic)NSString *PayTime;

@property(strong,nonatomic)NSString *CallBackTime;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
