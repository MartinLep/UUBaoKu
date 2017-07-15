//
//  CheckMemberCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/21.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"
@class FriendListModel;

@interface CheckMemberCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;
@property (nonatomic, strong) FriendListModel *friendlistModel;
@end
