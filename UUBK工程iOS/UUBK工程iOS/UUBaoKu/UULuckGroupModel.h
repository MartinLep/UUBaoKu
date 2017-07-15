//
//  UULuckGroupModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UULuckGroupModel : QZHModel

@property(nonatomic,strong)NSString *GoodsName;
@property(nonatomic,strong)NSString *GoodsTitle;
@property(nonatomic,strong)NSString *GoodsInfo;
@property(nonatomic,strong)NSString *GoodsID;
@property(nonatomic,strong)NSString *ProductID;
@property(nonatomic,strong)NSArray *Images;
@property(nonatomic,strong)NSNumber *TuanID;
@property(nonatomic,strong)NSString *TuanNo;
@property(nonatomic,strong)NSNumber *HasBuyNum;
@property(nonatomic,strong)NSNumber *TotalBuyNum;
@property(nonatomic,strong)NSNumber *RemainBuyNum;
@property(nonatomic,strong)NSString *State;
@property(nonatomic,strong)NSArray *ParticipantRecord;
@property(nonatomic,strong)NSDictionary *CurrentUserRecord;
@end
