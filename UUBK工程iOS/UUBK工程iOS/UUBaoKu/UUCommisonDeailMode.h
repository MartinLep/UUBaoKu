//
//  UUCommisonDeailMode.h
//  UUBaoKu
//
//  Created by dev on 17/2/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUCommisonDeailMode : NSObject

@property(strong,nonatomic)NSString *Mobile;
@property(strong,nonatomic)NSNumber *CommisionAmcount;
@property(assign,nonatomic)NSInteger CommisionLevel;
@property(strong,nonatomic)NSString *OrderNO;
@property(strong,nonatomic)NSNumber *OrderCommssionTotalMoney;
@property(strong,nonatomic)NSNumber *CommissonRatio;
@property(strong,nonatomic)NSString *CreateTime;
@property(strong,nonatomic)NSNumber *CommssionType;
@property(strong,nonatomic)NSString *CommssionTypeName;
@property(strong,nonatomic)NSString *FaceImg;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
