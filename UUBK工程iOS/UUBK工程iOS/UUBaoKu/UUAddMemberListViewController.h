//
//  UUAddMemberListViewController.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/21.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"
#import "UUShareInfoModel.h"
@interface UUAddMemberListViewController : UUBaseViewController
@property (nonatomic,copy) void(^completeAdd)();
@property (nonatomic, copy) void(^getMemberlsit)(NSArray *array,NSMutableArray *listArr);
@property (nonatomic, copy) NSString *groupChatId;
@property (nonatomic,strong)NSArray *hasMembers;
@property (nonatomic,assign)NSInteger isCreate; //=1:新建
@property (nonatomic,assign)NSInteger isShare; //=1:分享
@property (nonatomic,strong)UUShareInfoModel *shareModel;
@end
