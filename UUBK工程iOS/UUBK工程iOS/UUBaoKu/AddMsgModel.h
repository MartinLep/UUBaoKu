//
//  AddMsgModel.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface AddMsgModel : QZHModel
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *friendId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTimeFormat;
@property (nonatomic, copy) NSString *requestId;

@end
