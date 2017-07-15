//
//  ChatViewController.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"
@class FriendListModel;
@class GrouplistModel;
@interface ChatViewController : EaseMessageViewController <EaseMessageCellDelegate,EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) FriendListModel *friendlistModel;
@property (nonatomic, strong) GrouplistModel *grouplistModel;
@end
