//
//  UUJoinDescCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUJoinDescCell.h"

@implementation UUJoinDescCell
- (IBAction)joinedTeam:(UIButton *)sender {
    [self.delegate goToJoinTeamWithIndexPath:sender.indexPath];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UUOtherGroupModel *)model{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_model.UserIcon] placeholderImage:HolderImage];
    self.mobileLab.text = _model.UserName;
    self.descLab.text = [NSString stringWithFormat:@"还差%ld人成团",_model.TotalNum.integerValue- _model.AssignedNum.integerValue];
    if (_model.IsSuccess.integerValue == 2) {
        self.joinBtn.hidden = YES;
    }else if (_model.IsSuccess.integerValue == 0){
        self.statusLab.hidden = YES;
    }else{
        self.joinBtn.hidden = YES;
        self.statusLab.textColor = UURED;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
