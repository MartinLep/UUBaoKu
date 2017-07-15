//
//  AddressBookListCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "AddressBookListCell.h"
#import "FriendListModel.h"

@implementation AddressBookListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kImageViewRadius(self.friendIcon, self.friendIcon.width/2);
}
- (void)setFriendlistModel:(FriendListModel *)friendlistModel {
    _friendlistModel = friendlistModel;
    [self.friendIcon sd_setImageWithURL:[NSURL URLWithString:friendlistModel.userIcon] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:friendlistModel.userName];
    if (isMatch) {
        self.friendName.text =  [friendlistModel.userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else{
        self.friendName.text = friendlistModel.userName;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
