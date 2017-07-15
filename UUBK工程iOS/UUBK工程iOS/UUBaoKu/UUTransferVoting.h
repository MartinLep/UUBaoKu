//
//  UUTransferVoting.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/26.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUTransferVoting : QZHModel
@property(nonatomic,assign)BOOL agree;
@property(nonatomic,assign)BOOL hasVoted;
@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,strong)NSNumber *sourceUserId;
@property(nonatomic,strong)NSString *sourceUserName;
@property(nonatomic,strong)NSNumber *targetUserId;
@property(nonatomic,strong)NSString *targetUserName;
@end
