//
//  CheckMemberCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/21.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "CheckMemberCell.h"
#import "FriendListModel.h"

@implementation CheckMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kImageViewRadius(self.userIcon, self.userIcon.width/2);
}

- (void)setFriendlistModel:(FriendListModel *)friendlistModel {
    _friendlistModel = friendlistModel;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:friendlistModel.userIcon] placeholderImage:HolderImage];
    self.userName.text = friendlistModel.userName;
    if (friendlistModel.isSelected) {
        self.selectImg.image = [UIImage imageNamed:@"关注选中按钮"];
        
    } else {
        self.selectImg.image = [UIImage imageNamed:@"选择行数按钮"];
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
