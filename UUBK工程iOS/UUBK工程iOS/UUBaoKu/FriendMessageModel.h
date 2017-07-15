//
//  FriendMessageModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/5.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface FriendMessageModel : QZHModel

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSDictionary *comment;
@property (nonatomic,strong)NSString *interactType;
@property (nonatomic,strong)NSString *userIcon;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *createTimeFormat;
@property (nonatomic,strong)NSDictionary *moment;
@end
