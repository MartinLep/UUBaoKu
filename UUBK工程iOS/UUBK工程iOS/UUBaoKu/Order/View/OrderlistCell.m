//
//  OrderlistCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "OrderlistCell.h"
#import "BuyCarListModel.h"
#import "UUSkuidModel.h"
#import "UUGroupDetailModel.h"
#import "UUBQDetailModel.h"
#import "UULuckGroupModel.h"
@implementation OrderlistCell

- (void)setBuyCarlistModel:(BuyCarListModel *)buyCarlistModel {
    _buyCarlistModel = buyCarlistModel;
    [self.GoodsIcon sd_setImageWithURL:[NSURL URLWithString:buyCarlistModel.ImgUrl] placeholderImage:nil];
    if ([buyCarlistModel.BuyPrice integerValue] == 0) {
      self.vipPrice.text = [NSString stringWithFormat:@"会员价 ¥%.2f",[buyCarlistModel.MemberPrice floatValue]];
    } else {
        self.vipPrice.text = [NSString stringWithFormat:@"采购价 ¥%.2f",[buyCarlistModel.BuyPrice floatValue]];
    }
    self.oringinalPrice.text = [NSString stringWithFormat:@"¥%.2f",[buyCarlistModel.MarketPrice floatValue]];
    self.unit.text = [NSString stringWithFormat:@"x%ld",[buyCarlistModel.CartNum integerValue]];
    self.goodType.text = buyCarlistModel.SpecShowName;
    self.goodsDetail.text = buyCarlistModel.GoodsName;
}

- (void)setSkuidModel:(UUSkuidModel *)SkuidModel {
    _SkuidModel = SkuidModel;
    [self.GoodsIcon sd_setImageWithURL:[NSURL URLWithString:SkuidModel.ImgUrl] placeholderImage:nil];
    if (KString(self.promotionID).length) {
        self.vipPrice.text = [NSString stringWithFormat:@"活动价 ¥%.2f",SkuidModel.ActivePrice];
        self.oringinalPrice.text = [NSString stringWithFormat:@"原价 ￥%.2f",SkuidModel.OriginalPrice];
    } else {
        if (SkuidModel.BuyPrice == 0) {
            self.vipPrice.text = [NSString stringWithFormat:@"会员价 ¥%.2f",SkuidModel.MemberPrice];
        } else {
            self.vipPrice.text = [NSString stringWithFormat:@"采购价 ¥%.2f",SkuidModel.BuyPrice];
        }
        self.oringinalPrice.text = [NSString stringWithFormat:@"¥%.2f",SkuidModel.MarketPrice];
    }
    
    self.goodType.text = SkuidModel.SpecShowName;
}

- (void)setGroupModel:(UUGroupDetailModel *)groupModel {
    _groupModel = groupModel;
    [self.GoodsIcon sd_setImageWithURL:[NSURL URLWithString:groupModel.Images[0]]];
    self.goodsDetail.text = groupModel.GoodsName;
    self.oringinalPrice.text = [NSString stringWithFormat:@"原价 ￥%.2f",groupModel.MemberPrice];
    self.vipPrice.text = [NSString stringWithFormat:@"团购价 ¥%.2f",groupModel.TeamBuyPrice];
    self.goodType.text = [NSString stringWithFormat:@"%@人团",KString(groupModel.GroupPrice[0][@"TeamBuyNum"])];
}

- (void)setBQModel:(UUBQDetailModel *)BQModel{
    _BQModel = BQModel;
    [self.GoodsIcon sd_setImageWithURL:[NSURL URLWithString:_BQModel.Images[0]]];
    self.goodsDetail.text = _BQModel.GoodsName;
    self.oringinalPrice.text = [NSString stringWithFormat:@"原价 ￥%.2f",_BQModel.MemberPrice.floatValue];
    self.vipPrice.text = [NSString stringWithFormat:@"团购价 ¥%.2f",_BQModel.TeamBuyPrice.floatValue];
    self.goodType.text = [NSString stringWithFormat:@"%@人团",KString(_BQModel.TeamBuyNum)];
}

- (void)setLuckModel:(UULuckGroupModel *)luckModel{
    _luckModel = luckModel;
    [self.GoodsIcon sd_setImageWithURL:[NSURL URLWithString:_luckModel.Images[0]]];
    self.goodsDetail.text = _luckModel.GoodsName;
//    self.oringinalPrice.text = @"¥0.00";
    self.oringinalPrice.hidden = YES;
    self.vipPrice.hidden = YES;
    self.lineLab.hidden = YES;
    self.goodType.text = [NSString stringWithFormat:@"%@人团",KString(_luckModel.HasBuyNum)];
}
#pragma mark -- 返回购物车
- (IBAction)goBackBuyCar:(id)sender {
    [self.delegate backToBuyCar];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
