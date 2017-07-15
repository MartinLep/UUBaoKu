//
//  UUMessageHomeCommentTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/12/28.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUMessageHomeCommentTableViewCell.h"

@implementation UUMessageHomeCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUMessageHomeCommentTableViewCell";
    UUMessageHomeCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUMessageHomeCommentTableViewCell" owner:nil options:nil][0];
    }
    return cell;
}


@end
