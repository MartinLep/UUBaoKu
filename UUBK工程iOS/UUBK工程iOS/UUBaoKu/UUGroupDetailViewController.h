//
//  UUGroupDetailViewController.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"
#import "GrouplistModel.h"

@interface UUGroupDetailViewController : UUBaseViewController
@property (nonatomic, strong) GrouplistModel *grouplistModel;
@property (nonatomic, copy) NSString *groupChatId;
@end
