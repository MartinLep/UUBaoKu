//
//  UUJoinModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUJoinModel : QZHModel

@property(nonatomic,strong)NSString *NickName;
@property(nonatomic,strong)NSString *FaceImg;
@property(nonatomic,strong)NSNumber *JoinNum;
@property(nonatomic,strong)NSString *IP;
@property(nonatomic,strong)NSString *JoinTime;
@property(nonatomic,strong)NSArray *JoinLuckyNos;
@end
