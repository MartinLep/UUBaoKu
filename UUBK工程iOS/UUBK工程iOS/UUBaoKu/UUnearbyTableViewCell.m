//
//  UUnearbyTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/10/26.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUnearbyTableViewCell.h"
#import "NearFriendlistModel.h"
#import "AddressBookModel.h"

@implementation UUnearbyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconimageView.layer.masksToBounds =YES;
    self.iconimageView.layer.cornerRadius = self.iconimageView.width/2;
    kButtonRadius(self.addBtn, 5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUnearbyTableViewCell";
    UUnearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUnearbyTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}

- (void)setNearModel:(NearFriendlistModel *)nearModel {
    _nearModel = nearModel;
    [self.iconimageView sd_setImageWithURL:[NSURL URLWithString:nearModel.userIcon] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.name.text = nearModel.userName;
    self.distance.text = [NSString stringWithFormat:@"%@米",nearModel.distance];
}

- (void)setAddressModel:(AddressBookModel *)addressModel {
    _addressModel = addressModel;
    self.name.text = addressModel.addressName;
    self.distance.text = addressModel.userName;
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
        
        [self.iconimageView sd_setImageWithURL:[NSURL URLWithString:addressModel.icon]];
    } else {
        [self.addBtn setTitle:@"短信邀请" forState:UIControlStateNormal];
        [self.addBtn setBackgroundColor:UURED];
        [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.iconimageView.image = [UIImage imageNamed:addressModel.icon];
    }
}
#pragma mark -- 添加好友
- (IBAction)addFriend:(id)sender {
    if (self.addFriend) {
        self.addFriend();
    }
}

@end
