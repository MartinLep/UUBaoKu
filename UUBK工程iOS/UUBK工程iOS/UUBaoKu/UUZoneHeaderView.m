//
//  UUZoneHeaderView.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUZoneHeaderView.h"

@implementation UUZoneHeaderView

- (void)setUserNameStr:(NSString *)userNameStr{
    _userNameStr = userNameStr;
    if (!_userNameStr) {
        _userNameStr = @"...";
    }
    NSString *textStr = kAString(_userNameStr, @"的优物空间");
    CGSize size = [textStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.5*SCALE_WIDTH]}];
    self.backViewWidth.constant = 51.5*SCALE_WIDTH+20+size.width;
    self.backViewHeight.constant = 51.5*SCALE_WIDTH;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:UURED range:NSMakeRange(textStr.length-4, 4)];
    self.userNameLab.font = [UIFont systemFontOfSize:17.5*SCALE_WIDTH];
    self.userNameLab.attributedText = attrStr;
}

- (void)setIconStr:(NSString *)iconStr{
    _iconStr = iconStr;
    self.iconView.layer.cornerRadius = 51.5*SCALE_WIDTH*0.5;
    self.iconView.layer.masksToBounds = YES;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_iconStr] placeholderImage:HolderImage];
}

- (void)setLevelDescStr:(NSString *)levelDescStr{
    _levelDescStr = levelDescStr;
    self.descLabel.font = [UIFont systemFontOfSize:12.5*SCALE_WIDTH];
    self.descLabel.text = _levelDescStr;
}

- (IBAction)assistRecommendAction:(UIButton *)sender {
    sender.selected = YES;
    self.primaryBtn.selected = NO;
    self.exchangeType(NO);
}

- (IBAction)primaryRecommendAction:(UIButton *)sender {
    sender.selected = YES;
    self.assistBtn.selected = NO;
    self.exchangeType(YES);
}
@end
