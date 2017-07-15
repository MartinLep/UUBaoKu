//
//  UUMallModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUMallModel : NSObject

@property(strong,nonatomic)NSArray *LimitTimeBuy;
@property(strong,nonatomic)NSArray *SelectGroup;
@property(strong,nonatomic)NSArray *SpecialGroup;

@property(strong,nonatomic)NSArray *TenFreeShip;
@property(strong,nonatomic)NSArray *RushBuy;
@property(strong,nonatomic)NSArray *TodayPrice;
@property(strong,nonatomic)NSArray *Bulletin;
@property(strong,nonatomic)NSArray *Slide;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
