//
//  UUCommentGoodsCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCommentGoodsCell.h"

@implementation UUCommentGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UUGoodsModel *)model{
    _model = model;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl] placeholderImage:PLACEHOLDIMAGE];
    self.goodsName.text = model.GoodsName;
    self.goodsDesc.text = model.GoodsAttrName;
    self.goodsPrice.text = KString(model.OriginalPrice);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
