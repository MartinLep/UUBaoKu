//
//  UUFundingDetailModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/11.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUFundingDetailModel : NSObject
@property(strong,nonatomic)NSString *MoneyTypeName;
@property(strong,nonatomic)NSString *OrderNo;
@property(assign,nonatomic)float FinanceMoney;
@property(strong,nonatomic)NSString *CreateTime;
@property(assign,nonatomic)float Fee;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
