//
//  UUFriendDetailViewController.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"
@class FriendListModel;
@class NearFriendlistModel;
@interface UUFriendDetailViewController : UUBaseViewController
@property (nonatomic, strong) FriendListModel *friendlistModel;
@property (nonatomic, strong) NearFriendlistModel *nearFriendModel;
@property (nonatomic, strong) NSDictionary *UserDict;
/**
 好友id
 */
@property (nonatomic, copy) NSString *friendId;
@end
