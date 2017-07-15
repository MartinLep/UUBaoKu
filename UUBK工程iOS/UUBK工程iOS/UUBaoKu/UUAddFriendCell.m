//
//  UUAddFriendCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/26.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUAddFriendCell.h"

@implementation UUAddFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImg.layer.masksToBounds =YES;
    self.iconImg.layer.cornerRadius = self.iconImg.width/2;
    self.addBtn.titleLabel.font = [UIFont systemFontOfSize:15*SCALE_WIDTH];
    self.width.constant = 90*SCALE_WIDTH;
    kButtonRadius(self.addBtn, 5);
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUAddFriendCell";
    UUAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUAddFriendCell" owner:nil options:nil][0];
    }
    
    return cell;
}


- (void)setAddressModel:(AddressBookModel *)addressModel {
    _addressModel = addressModel;
    self.nameLab.text = addressModel.addressName;
    self.descLab.text = addressModel.userName;
    if (addressModel.is_User) {
        if ([addressModel.is_Friend isEqualToString:@"0"]) {
            [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
            [self.addBtn setBackgroundColor:UURED];
            [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            [self.addBtn setTitle:@"已添加" forState:UIControlStateNormal];
            [self.addBtn setBackgroundColor:[UIColor whiteColor]];
            [self.addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:addressModel.icon]];
    } else {
        [self.addBtn setTitle:@"短信邀请" forState:UIControlStateNormal];
        [self.addBtn setBackgroundColor:UURED];
        [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.iconImg.image = [UIImage imageNamed:addressModel.icon];
    }
}
#pragma mark -- 添加好友

- (IBAction)addFriend:(id)sender {
    if (self.addFriend) {
        self.addFriend();
    }
}
@end
