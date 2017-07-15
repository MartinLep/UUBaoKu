//
//  UUZoneDetailModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUZoneDetailModel : QZHModel
@property(nonatomic,strong)NSNumber *collectsNum;
@property(nonatomic,strong)NSNumber *commentsNum;
@property(nonatomic,strong)NSArray *comments;
@property(nonatomic,strong)NSArray *goodsList;
@property(nonatomic,strong)NSArray *imgs;
@property(nonatomic,assign)BOOL isLike;
@property(nonatomic,strong)NSNumber *likesNum;
@property(nonatomic,strong)NSArray *netRecommendInfoList;
@property(nonatomic,strong)NSString *recommendLevelDesc;
@property(nonatomic,strong)NSNumber *stars;
@property(nonatomic,strong)NSString *userIcon;
@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *words;
@end
