//
//  UUOrderDetailModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/15.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUOrderDetailModel : NSObject
@property(strong,nonatomic)NSString *ShippingCode;
@property(strong,nonatomic)NSString *ShippingName;
@property(strong,nonatomic)NSString *LogisticsLogo;
@property(strong,nonatomic)NSArray *Logistics;





- (id)initWithDictionary:(NSDictionary *)dict;

@end
