//
//  UUUserZoneCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUUserZoneCell.h"

@implementation UUUserZoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUserNameStr:(NSString *)userNameStr{
    _userNameStr = userNameStr;
    if (!_userNameStr) {
        _userNameStr = @"...";
    }
    NSString *textStr = kAString(_userNameStr, @"的空间");
    CGSize size = [textStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    self.backViewWidth.constant = 52+20+size.width;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:UURED range:NSMakeRange(textStr.length-2, 2)];
    self.nameLab.attributedText = attrStr;
}

- (void)setLevelDescStr:(NSString *)levelDescStr{
    _levelDescStr = levelDescStr;
    _levelDescLab.text = _levelDescStr;
}

- (void)setIconImgStr:(NSString *)iconImgStr{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:iconImgStr] placeholderImage:HolderImage];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
