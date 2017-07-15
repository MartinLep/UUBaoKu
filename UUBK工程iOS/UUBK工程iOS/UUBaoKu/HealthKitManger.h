//
//  HealthKitManger.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/12.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

typedef void(^SCHealthBlock)(BOOL success, NSString *stepCount);
@interface HealthKitManger : NSObject
// 开启健康数据中心
- (void)setupHKHealthStore:(SCHealthBlock)block;
@end
