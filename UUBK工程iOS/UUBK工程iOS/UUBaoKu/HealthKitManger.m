//
//  HealthKitManger.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/12.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "HealthKitManger.h"
#import <HealthKit/HealthKit.h>
#define HKVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
#define CustomHealthErrorDomain @"com.sdqt.healthError"

@interface HealthKitManger()
@property (nonatomic, strong) HKHealthStore *healthStore;
@property (nonatomic, copy) SCHealthBlock block;

@end

@implementation HealthKitManger

// 开启健康数据中心
- (void)setupHKHealthStore:(SCHealthBlock)block {
    //查看healthKit在设备上是否可用，ipad不支持HealthKit
    if(![HKHealthStore isHealthDataAvailable]) {
        NSLog(@"设备不支持healthKit");
        block(NO, nil);
        return;
    }
    
    self.block = block;
    
    //创建healthStore实例对象
    self.healthStore = [[HKHealthStore alloc] init];
    
    //设置需要获取的权限这里仅设置了步数
    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSSet *healthSet = [NSSet setWithObjects:stepCount,nil];
    
    //从健康应用中获取权限
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"error=error==error===%@==",error);
        if (success) {
            NSLog(@"获取步数权限成功");
            //获取步数后我们调用获取步数的方法
            [self readStepCount];
        } else {
            NSLog(@"获取步数权限失败");
        }
    }];
}

// 查询数据
- (void)readStepCount {
    //查询采样信息
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    //NSSortDescriptors用来告诉healthStore怎么样将结果排序。
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    /*查询的基类是HKQuery，这是一个抽象类，能够实现每一种查询目标，这里我们需要查询的步数是一个
     HKSample类所以对应的查询类就是HKSampleQuery。
     下面的limit参数传1表示查询最近一条数据,查询多条数据只要设置limit的参数值就可以了
     */
    
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:[self predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        
        NSString *stepStr = @"";
        BOOL success = NO;
        if(!error && results) {
            //打印查询结果
            NSLog(@"resultCount = %d result = %@",results.count,results);
            if (results.count > 0) {
                NSInteger totleSteps = 0;
                for(HKQuantitySample *quantitySample in results) {
                    HKQuantity *quantity = quantitySample.quantity;
                    HKUnit *heightUnit = [HKUnit countUnit];
                    NSInteger usersHeight = (NSInteger)[quantity doubleValueForUnit:heightUnit];
                    totleSteps += usersHeight;
                }
                
                //把结果装换成字符串类型
                stepStr = [NSString stringWithFormat:@"%ld",(long)totleSteps];
                success = YES;
                NSLog(@"最新步数：%@",stepStr);
            }
        }
        
        if (self.block) {
            self.block(success, stepStr);
        }
    }];
    //执行查询
    [self.healthStore executeQuery:sampleQuery];
}


/*!
 *  获取当天的时间段
 *  @brief  当天时间段
 *
 *  @return 时间段
 */
- (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}
@end
