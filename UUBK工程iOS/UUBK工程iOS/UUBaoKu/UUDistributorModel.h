//
//  UUDistributorModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/6.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUDistributorModel : QZHModel

@property (nonatomic, strong)NSNumber *Degree;
@property (nonatomic, strong)NSNumber *Rebate;
@property (nonatomic, strong)NSString *DegreeName;
@property (nonatomic, strong)NSString *DegreeImageUrl;
@property (nonatomic, strong)NSNumber *MinSalesAmount;
@property (nonatomic, strong)NSNumber *Advance;
@end
