//
//  UUnearbyTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/10/26.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NearFriendlistModel;
@class AddressBookModel;
@interface UUnearbyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconimageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *distance;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, copy) void(^addFriend)();
@property (nonatomic, strong) NearFriendlistModel *nearModel;
@property (nonatomic, strong) AddressBookModel *addressModel;
@end

