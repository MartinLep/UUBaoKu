//
//  UUactivityCommentTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 17/1/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//===========活动详情评论使用的cell、 ＝＝＝＝＝＝＝＝

#import "UUactivityCommentTableViewCell.h"

@implementation UUactivityCommentTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"UUactivityCommentTableViewCell";
    UUactivityCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUactivityCommentTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}

- (void)addSubview:(UIView *)view{
    if (![view isKindOfClass:[NSClassFromString(@"UITableViewCellSeparatorView") class]] && view)
        [super addSubview:view];
}


@end
