//
//  UUOrderModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUOrderModel : NSObject

@property(strong,nonatomic)NSString *GoodsName;

@property(strong,nonatomic)NSString *GoodsId;

@property(strong,nonatomic)NSString *CreateTime;
@property(strong,nonatomic)NSString *Star;
@property(strong,nonatomic)NSString *Idea;
@property(strong,nonatomic)NSArray *ShareImg;
@property(strong,nonatomic)NSString *SpecName;
@property(strong,nonatomic)NSString *OrderNo;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
