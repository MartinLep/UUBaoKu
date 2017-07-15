//
//  UULuckJoinRecordCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UULuckJoinRecordCell.h"

@implementation UULuckJoinRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UUJoinModel *)model{
    _model = model;
    if (_model) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:_model.FaceImg] placeholderImage:HolderImage];
        self.mobileLab.text = _model.NickName;
        self.descLab.text = _model.IP;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"参与了%@人次 %@",_model.JoinNum,_model.JoinTime]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(5+KString(_model.JoinNum).length+1, _model.JoinTime.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:UURED range:NSMakeRange(3, KString(_model.JoinNum).length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(5+KString(_model.JoinNum).length+1, _model.JoinTime.length)];
        
        self.joinDescLab.attributedText = attrStr;
        if (self.isNotMe == 1) {
            self.LuckNosLab.hidden = YES;
        }else{
            NSMutableString *luckNos = [NSMutableString new];
            if ([self.model.JoinLuckyNos isKindOfClass:[NSArray class]]) {
                for (NSString *luckNo in self.model.JoinLuckyNos) {
                    [luckNos appendFormat:@"%@  ",luckNo];
                }

            }
            self.LuckNosLab.text = luckNos;
        }
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
