//
//  AddressBookListCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"
@class FriendListModel;

@interface AddressBookListCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *friendIcon;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (nonatomic, strong) FriendListModel *friendlistModel;
@end
