//
//  UUMessageHomeModel.h
//  UUBaoKu
//
//  Created by admin on 16/11/30.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUMessageHomeModel : NSObject
//用户名称
@property(strong,nonatomic)NSString *userName;
//用户头像
@property(strong,nonatomic)NSString *userIcon;
//发布时间
@property(strong,nonatomic)NSString *creatTime;
//产品图片
@property(strong,nonatomic)NSString *images;
//描述
@property(strong,nonatomic)NSString * description;
//好友评论
@property(strong,nonatomic)NSArray *comments;
//评论数
@property(assign,nonatomic)NSNumber *commentNum;

//点赞数
@property(assign,nonatomic)NSNumber *likeNum;
@end
