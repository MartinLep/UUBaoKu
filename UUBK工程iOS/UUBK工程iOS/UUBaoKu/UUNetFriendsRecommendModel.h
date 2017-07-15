//
//  UUNetFriendsRecommendModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/7.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUNetFriendsRecommendModel : QZHModel
@property(nonatomic,strong)NSArray *goodsList;
@property(nonatomic,strong)NSString *userIcon;
@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *words;
@end
