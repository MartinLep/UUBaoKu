//
//  UUBQGoodsDescCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBQGoodsDescCell.h"

@implementation UUBQGoodsDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UUBQDetailModel *)model{
    _model = model;
    self.howMuchTeamLab.text = [NSString stringWithFormat:@"%ld人团",_model.TeamBuyNum.integerValue];
    self.currentPriceLab.text = [NSString stringWithFormat:@"￥%.2f",_model.BuyPrice.floatValue];
    self.orginalPriceLab.text = [NSString stringWithFormat:@"￥%.2f",_model.MemberPrice.floatValue];
    self.joinedTeamLab.text = [NSString stringWithFormat:@"已有%ld人参团",_model.TotalBuyNum.integerValue];
    self.goodsNameLab.text = _model.GoodsName;
    self.goodsTitleLab.text = _model.GoodsTitle;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
