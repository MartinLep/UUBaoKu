//
//  UUSupplyListCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSupplyListCell.h"

@implementation UUSupplyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UUSupplyGoodsModel *)model{
    _model = model;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl] placeholderImage:PLACEHOLDIMAGE];
    self.goodsName.text = model.GoodsName;
    self.buyPrice.text = KString(model.PurchasePrice);
    self.supplyPrice.text = KString(model.DistributionPrice);
    self.stockNum.text = KString(model.StockNum);
    self.goodsType.text = model.GoodsSheilves;
    self.ckeckStatus.text = model.Status;
    self.time.text = model.OnShelfTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
