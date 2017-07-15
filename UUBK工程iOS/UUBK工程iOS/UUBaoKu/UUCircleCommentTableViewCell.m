//
//  UUCircleCommentTableViewCell.m
//  UUBaoKu
//
//  Created by dev on 17/4/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCircleCommentTableViewCell.h"
#import "UUZoneCommentModel.h"
@implementation UUCircleCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUCircleCommentTableViewCell";
    UUCircleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell= [[[NSBundle  mainBundle]  loadNibNamed:ID owner:self options:nil]  lastObject];
    }
    
    return cell;
}

- (void)setModel:(UUZoneCommentModel *)model{
    _model = model;
    self.likeBtn.selected = _model.isLike;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:_model.userIcon] placeholderImage:HolderImage];
    self.nameLab.text = _model.userName;
    self.contentLab.text = _model.content;
    self.timeLab.text = _model.createTimeFormat;
    self.numLab.text = KString(_model.likesNum);
}

- (void)likeBtnAction:(UIButton *)sender{
    sender.tag = _model.commentId.integerValue+1000;
    [self.delegate clickLikeWithCell:self andSender:sender];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
