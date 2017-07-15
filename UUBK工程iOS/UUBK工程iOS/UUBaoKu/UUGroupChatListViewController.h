//
//  UUGroupChatListViewController.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"
#import "UUShareInfoModel.h"
@interface UUGroupChatListViewController : UUBaseViewController
@property(nonatomic,assign)NSInteger isShare;
@property(nonatomic,strong)UUShareInfoModel *shareModel;
@end
