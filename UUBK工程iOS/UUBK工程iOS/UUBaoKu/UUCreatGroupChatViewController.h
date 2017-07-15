//
//  UUCreatGroupChatViewController.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/19.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"


@interface UUCreatGroupChatViewController : UUBaseViewController
/**
   区分建群和建组 1:建群聊 2:建分组 3:编辑分组
 */
@property (nonatomic, copy) NSString *sign;

/**
   编辑分组传入的组id
 */
@property (nonatomic, copy) NSString *group_id;

@property(nonatomic,strong)void(^completedCreate)();

@end
