//
//  FriendListModel.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface FriendListModel : QZHModel
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *userName2;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) BOOL isSelected;

@end
