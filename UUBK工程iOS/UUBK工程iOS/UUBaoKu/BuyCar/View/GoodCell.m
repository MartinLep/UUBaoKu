//
//  GoodCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "GoodCell.h"
#import "GuesslikeModel.h"
#import "UUMallGoodsModel.h"
@implementation GoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kButtonRadius(self.makeCoinBtn, 3);
    self.iconHeightConstraint.constant = (kScreenWidth-40)/2;
    // Initialization code
}

- (void)setGuessModel:(GuesslikeModel *)guessModel {
    _guessModel = guessModel;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:guessModel.Images[0]] placeholderImage:PLACEHOLDIMAGE];
    self.name.text = guessModel.GoodsName;
    self.originalPrice.text = [NSString stringWithFormat:@"原价:¥%.2f",[KString(guessModel.MarketPrice) floatValue]] ;
    if (guessModel.BuyPrice != 0) {
        self.vipPrice.text = [NSString stringWithFormat:@"采购价:¥%.2f",[KString(guessModel.BuyPrice) floatValue]];
    }else{
        self.vipPrice.text = [NSString stringWithFormat:@"会员价:¥%.2f",[KString(guessModel.MemberPrice) floatValue]];
    }
   
    
}

- (void)setAllBuyModel:(UUMallGoodsModel *)allBuyModel{
    _allBuyModel = allBuyModel;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:allBuyModel.Images[0]] placeholderImage:PLACEHOLDIMAGE];
    self.name.text = allBuyModel.GoodsName;
    self.originalPrice.text = [NSString stringWithFormat:@"原价:¥%.2f",allBuyModel.MarketPrice] ;
    if (allBuyModel.BuyPrice != 0) {
        self.vipPrice.text = [NSString stringWithFormat:@"采购价:¥%.2f",allBuyModel.BuyPrice];
    }else{
        self.vipPrice.text = [NSString stringWithFormat:@"会员价:¥%.2f",allBuyModel.MemberPrice];
    }
}
- (IBAction)earnKubi:(UIButton *)sender {
    [self.delegate goToEarnKubiWithIndexPath:sender.indexPath];
}



@end
