//
//  UUStockMoneyDetailMode.h
//  UUBaoKu
//
//  Created by dev on 17/2/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUStockMoneyDetailMode : NSObject

@property(strong,nonatomic)NSString *IntegralType;
@property(strong,nonatomic)NSNumber *IntegralNum;
@property(strong,nonatomic)NSString *CreateTime;
@property(strong,nonatomic)NSString *IntegralTypeName;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
