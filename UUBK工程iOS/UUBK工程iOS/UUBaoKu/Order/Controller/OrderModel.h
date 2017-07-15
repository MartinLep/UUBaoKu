//
//  OrderModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/11.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface OrderModel : QZHModel
@property (nonatomic,strong)NSString *appid;
@property (nonatomic,strong)NSString *partnerid;
@property (nonatomic,strong)NSString *prepayid;
@property (nonatomic,strong)NSString *package;
@property (nonatomic,strong)NSString *noncestr;
@property (nonatomic,strong)NSNumber *timestamp;
@property (nonatomic,strong)NSString *sign;

@end
