//
//  UUAddFriendCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/26.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearFriendlistModel.h"
#import "AddressBookModel.h"
@interface UUAddFriendCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, copy) void(^addFriend)();
@property (nonatomic, strong) NearFriendlistModel *nearModel;
- (IBAction)addFriend:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (nonatomic, strong) AddressBookModel *addressModel;
@end
