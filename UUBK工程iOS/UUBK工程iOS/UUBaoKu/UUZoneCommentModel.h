//
//  UUZoneCommentModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUZoneCommentModel : QZHModel
@property(nonatomic,strong)NSNumber *commentId;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSNumber *createTime;
@property(nonatomic,strong)NSString *createTimeFormat;
@property(nonatomic,assign)BOOL isLike;
@property(nonatomic,strong)NSNumber *likesNum;
@property(nonatomic,strong)NSString *userIcon;
@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSString *userName;
@end
