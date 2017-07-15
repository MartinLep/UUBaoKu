//
//  UUSelectedGoodsCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/7/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSelectedGoodsCell.h"
#import "UULinkGoodsModel.h"
#import "UUAttentionGoodsModel.h"
#import "UUBoughtGoodsModel.h"
@implementation UUSelectedGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLinkModel:(UULinkGoodsModel *)linkModel{
    _linkModel = linkModel;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_linkModel.ImageUrl] placeholderImage:PLACEHOLDIMAGE];
    self.goodsName.text = _linkModel.GoodsName;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",_linkModel.GoodsPrice.floatValue];
    self.selectedBtn.hidden = YES;
}

- (void)setAttentionModel:(UUAttentionGoodsModel *)attentionModel{
    _attentionModel = attentionModel;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_attentionModel.ImageUrl] placeholderImage:PLACEHOLDIMAGE];
    self.goodsName.text = _attentionModel.GoodsName;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",IS_DISTRIBUTOR?_attentionModel.BuyPrice.floatValue:_attentionModel.MemberPrice.floatValue];
}

- (void)setBoughtModel:(UUBoughtGoodsModel *)boughtModel{
    _boughtModel = boughtModel;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_boughtModel.ImageUrl] placeholderImage:PLACEHOLDIMAGE];
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",_boughtModel.CostPrice.floatValue];
    self.goodsName.text = _boughtModel.GoodsName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
