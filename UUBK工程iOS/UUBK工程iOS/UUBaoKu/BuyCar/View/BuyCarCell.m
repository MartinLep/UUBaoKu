//
//  BuyCarCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/22.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "BuyCarCell.h"
#import "BuyCarListModel.h"
@implementation BuyCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.selectedBtn setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateSelected];
    [self.selectedBtn setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
}
- (void)setBuyCarModel:(BuyCarListModel *)buyCarModel {
    _buyCarModel = buyCarModel;
    self.nameLabel.text = buyCarModel.GoodsName;
    self.vipPriceTitle.font = [UIFont systemFontOfSize:14*SCALE_WIDTH];
    self.vipPrice.font = [UIFont systemFontOfSize:14*SCALE_WIDTH];
    self.normalPrice.font = [UIFont systemFontOfSize:14*SCALE_WIDTH];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"IsDistributor"] integerValue] == 1) {
        self.vipPriceTitle.text = @"采购价";
        self.vipPrice.text = [NSString stringWithFormat:@"¥ %.2f",[buyCarModel.BuyPrice floatValue]];
        self.normalPrice.text = [NSString stringWithFormat:@"会员价 : ¥ %.2f",[buyCarModel.MemberPrice floatValue]];
    }else{
        self.vipPriceTitle.text = @"会员价";
        self.vipPrice.text = [NSString stringWithFormat:@"¥ %.2f",[buyCarModel.MemberPrice floatValue]];
        self.normalPrice.text = [NSString stringWithFormat:@"市场价 : ¥ %.2f",[buyCarModel.MarketPrice floatValue]];
    }
    
    self.unitLabel.text = [NSString stringWithFormat:@"%@",buyCarModel.CartNum];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:buyCarModel.ImgUrl] placeholderImage:nil];
    self.selectedBtn.selected = self.is_Selected;
}

#pragma mark -- 购物车增减
- (IBAction)countChangeClick:(id)sender {
    [self.delegate countChange:sender Cell:self];
}

@end
