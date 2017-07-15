//
//  UULuckDescTableViewCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UULuckDescTableViewCell.h"

@implementation UULuckDescTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UULuckGroupModel *)model{
    _model = model;
    if (_model) {
        self.statusLab.text = _model.State;
        self.goodsNameLab.text = _model.GoodsName;
        self.goodsTitleLab.text = _model.GoodsTitle;
        self.privateCodeLab.text = _model.TuanNo;
        self.sliderWidth.constant = (kScreenWidth - 18- 15)*_model.HasBuyNum.integerValue/_model.TotalBuyNum.integerValue;
        self.totalNumLab.text = KString(_model.TotalBuyNum);
        self.hasJoinedNumLab.text = KString(_model.HasBuyNum);
        self.needNumLab.text = KString(_model.RemainBuyNum);

    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
