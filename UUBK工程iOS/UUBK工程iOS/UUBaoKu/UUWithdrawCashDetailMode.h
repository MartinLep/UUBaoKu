//
//  UUWithdrawCashDetailMode.h
//  UUBaoKu
//
//  Created by dev on 17/2/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUWithdrawCashDetailMode : NSObject

@property(strong,nonatomic)NSString *BankCardID;
@property(strong,nonatomic)NSNumber *WithDrawMoney;
@property(assign,nonatomic)NSInteger WithDrawType;
@property(strong,nonatomic)NSString *WithDrawTypeName;
@property(assign,nonatomic)NSInteger CheckStatu;
@property(strong,nonatomic)NSString *CreateTime;
@property(strong,nonatomic)NSString *CheckTime;
@property(strong,nonatomic)NSString *BankName;
@property(strong,nonatomic)NSString *ImgUrl;
@property(assign,nonatomic)NSInteger totalCount;
- (id)initWithDictionary:(NSDictionary *)dict;
@end
