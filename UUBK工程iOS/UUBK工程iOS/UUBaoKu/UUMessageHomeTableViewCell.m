//
//  UUMessageHomeTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/10/21.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUMessageHomeTableViewCell.h"
#import "Masonry.h"
#import "UUMessageHomeCommentTableViewCell.h"
#import "UUCommentModel.h"

@implementation UUMessageHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.DetailsBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
    [self.DetailsBtn setTitle:@"推荐详情" forState:UIControlStateNormal];
    self.DetailsBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.DetailsBtn.layer.cornerRadius =2.5;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUMessageHomeTableViewCell";
    UUMessageHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUMessageHomeTableViewCell" owner:nil options:nil][0];
    }
    return cell;
}

- (void)setCommentsArray:(NSArray *)commentsArray{
    _commentsArray = commentsArray;
    CGFloat topSpacing = 0;
    for (NSDictionary *dict in _commentsArray) {
        UUCommentModel *model = [[UUCommentModel alloc]initWithDict:dict];
        NSString *contentStr = [NSString stringWithFormat:@"%@:%@",model.userName,model.content];
        CGSize size = [contentStr boundingRectWithSize:CGSizeMake(kScreenWidth-25, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, topSpacing, self.commentBackView.width, size.height)];
        label.font = [UIFont systemFontOfSize:13];
        label.numberOfLines = 0;
        label.textColor = UUGREY;
        label.text = contentStr;
        [self.commentBackView addSubview:label];
        topSpacing += size.height+5;
    }
    self.commentBackViewHeight.constant = topSpacing;
}
@end
