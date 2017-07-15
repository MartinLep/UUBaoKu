//
//  UURecommendGoodsListCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UURecommendGoodsListCell.h"
#import "UULinkGoodsModel.h"
#import "UUAttentionGoodsModel.h"
#import "UUBoughtGoodsModel.h"

@implementation UURecommendGoodsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsDetailBtn.layer.cornerRadius = 2.5;
    self.goodsDetailBtn.layer.borderColor = UURED.CGColor;
    self.goodsDetailBtn.layer.borderWidth = 1.0;
    // Initialization code
}
- (IBAction)goodsDetailAction:(UIButton *)sender {
    [self.delegate goToGoodsDetailWithIndexPath:sender.indexPath];
}

- (void)setLinkModel:(UULinkGoodsModel *)linkModel{
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:linkModel.ImageUrl] placeholderImage:PLACEHOLDIMAGE];
    self.goodsName.text = linkModel.GoodsName;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",linkModel.GoodsPrice.floatValue];
    self.goodsSale.hidden = YES;
}

- (void)setAttentionModel:(UUAttentionGoodsModel *)attentionModel{
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:attentionModel.ImageUrl] placeholderImage:PLACEHOLDIMAGE];
    self.goodsName.text = attentionModel.GoodsName;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",IS_DISTRIBUTOR?attentionModel.BuyPrice.floatValue:attentionModel.MemberPrice.floatValue];
    self.goodsSale.hidden = NO;
    self.goodsSale.text = [NSString stringWithFormat:@"销量：%@",attentionModel.GoodsSaleNum];
}

- (void)setBoughtModel:(UUBoughtGoodsModel *)boughtModel{
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:boughtModel.ImageUrl] placeholderImage:PLACEHOLDIMAGE];
    self.goodsName.text = boughtModel.GoodsName;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",boughtModel.CostPrice.floatValue];
    self.goodsSale.hidden = NO;
    self.goodsSale.text = [NSString stringWithFormat:@"销量：%@",boughtModel.GoodsSaleNum];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
