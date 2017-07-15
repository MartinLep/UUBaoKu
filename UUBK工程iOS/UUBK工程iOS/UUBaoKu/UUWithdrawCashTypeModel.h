//
//  UUWithdrawCashTypeModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUWithdrawCashTypeModel : NSObject

@property(strong,nonatomic)NSString *Desction;
@property(strong,nonatomic)NSString *EnumName;
@property(assign,nonatomic)NSInteger EnumValue;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
