//
//  GrouplistCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "GrouplistCell.h"
#import "GrouplistModel.h"

@implementation GrouplistCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    kImageViewRadius(self.groupIcon, self.groupIcon.width/2);
}

- (void)setGrouplistModel:(GrouplistModel *)grouplistModel {
    _grouplistModel = grouplistModel;
    [self.groupIcon sd_setImageWithURL:[NSURL URLWithString:grouplistModel.groupChatIcon] placeholderImage:[UIImage imageNamed:@"群头像"]];
    NSString *string = [NSString stringWithFormat:@"%@(%@人)",grouplistModel.groupChatName,grouplistModel.membersNum];
    self.groupName.text = string;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
