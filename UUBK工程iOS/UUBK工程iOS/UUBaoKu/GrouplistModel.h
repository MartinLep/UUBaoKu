//
//  GrouplistModel.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface GrouplistModel : QZHModel
@property (nonatomic, copy) NSString *groupChatName;
@property (nonatomic, copy) NSString *groupChatId;
@property (nonatomic, copy) NSString *holderId;
@property (nonatomic, copy) NSString *membersNum;
@property (nonatomic, copy) NSString *groupChatIcon;
@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic, copy) NSDictionary *setting;
@end
