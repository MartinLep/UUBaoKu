//
//  Person.h
//  UUBaoKu
//
//  Created by admin on 17/1/4.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (strong , nonatomic) NSString * name;//用户名
@property (assign , nonatomic) NSInteger number;//用户号码
@property(strong,nonatomic)NSString *distributionLevelDesc;//分销等级
@property(strong,nonatomic)NSString *SupplierDegreeName;//供货等级
@property(strong,nonatomic)NSString *userIconStr;//用户头像

@property(assign,nonatomic)NSInteger userId;//用户id

@property(assign,nonatomic)NSInteger isDistributor;//是否分销商
@property(assign,nonatomic)NSInteger isSupplier;//是否供货商
@property(assign,nonatomic)float balance;//囤货金
@property(assign,nonatomic)NSInteger integral;//库币数


//构造字典
- (id)initWithDictionary:(NSDictionary*)jsonDic;
@end
