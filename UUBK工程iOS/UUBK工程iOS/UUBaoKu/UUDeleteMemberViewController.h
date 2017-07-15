//
//  UUDeleteMemberViewController.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/22.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"

@interface UUDeleteMemberViewController : UUBaseViewController
@property (nonatomic,copy) void(^completeDel)();
@property (nonatomic, copy) void(^getMemberlsit)(NSArray *array,NSMutableArray *listArr);
@property (nonatomic, strong) NSMutableArray *grouplistIdArr;
@property (nonatomic, strong)NSString *groupChatId;
@property (nonatomic, assign)NSInteger isCreate; //=1:新建
/**
   判读是否是新建群聊
 */
@property (nonatomic, assign) BOOL isNew;
@end
