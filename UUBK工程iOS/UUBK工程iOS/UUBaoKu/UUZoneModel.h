//
//  UUZoneModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUZoneModel : QZHModel
@property(nonatomic,strong)NSArray *assist;
@property(nonatomic,strong)NSArray *primary;
@property(nonatomic,strong)NSString *recommendLevelDesc;
@property(nonatomic,strong)NSNumber *recommendLevel;
@property(nonatomic,strong)NSString *userIcon;
@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSString *userName;
@end
