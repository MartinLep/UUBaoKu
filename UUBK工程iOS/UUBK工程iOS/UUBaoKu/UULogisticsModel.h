//
//  UULogisticsModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UULogisticsModel : NSObject

@property(strong,nonatomic)NSString *Msg;
@property(strong,nonatomic)NSString *Time;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
