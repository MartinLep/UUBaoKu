//
//  UUHotArticles.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUHotArticles : QZHModel

@property(nonatomic,strong)NSNumber *commentsNum;
@property(nonatomic,strong)NSNumber *createTime;
@property(nonatomic,strong)NSString *createTimeFormat;
@property(nonatomic,strong)NSArray *goodsList;
@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,strong)NSArray *imgs;
@property(nonatomic,strong)NSNumber *likesNum;
@property(nonatomic,strong)NSNumber *recommendType;
@property(nonatomic,strong)NSString *userIcon;
@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSString *userName;
@end
