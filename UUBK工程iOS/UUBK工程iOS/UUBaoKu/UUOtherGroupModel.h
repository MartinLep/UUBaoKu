//
//  UUOtherGroupModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUOtherGroupModel : QZHModel
@property(nonatomic,strong)NSString *TeamID;
@property(nonatomic,strong)NSString *JoinID;
@property(nonatomic,strong)NSNumber *TotalNum;
@property(nonatomic,strong)NSNumber *AssignedNum;
@property(nonatomic,strong)NSString *UserName;
@property(nonatomic,strong)NSString *UserIcon;
@property(nonatomic,strong)NSString *EndDate;
@property(nonatomic,strong)NSNumber *IsSuccess;
@end
