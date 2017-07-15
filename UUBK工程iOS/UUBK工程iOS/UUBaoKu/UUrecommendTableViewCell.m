//
//  UUrecommendTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/4.
//  Copyright © 2016年 loongcrown. All rights reserved.
//======================编写分享控制器里的推荐列表==============================

#import "UUrecommendTableViewCell.h"

@implementation CALayer(XibConfiguration)
-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}
-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
@implementation UUrecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUrecommendTableViewCell";
    UUrecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUrecommendTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}

- (void)setGoodsModel:(UUNetGoodsModel *)goodsModel{
    _goodsModel = goodsModel;
    self.userName.text = _goodsModel.goodsName;
    [self.img sd_setImageWithURL:[NSURL URLWithString:_goodsModel.img]];
    self.price.text = [NSString stringWithFormat:@"￥%.2f",_goodsModel.price.floatValue];
    self.goodsId = KString(_goodsModel.goodsId);
    self.url = _goodsModel.url;
    if (!_goodsModel.salesNum) {
        self.salesNum.hidden = YES;
    }else{
        self.salesNum.text = [NSString stringWithFormat:@"销量：%@",_goodsModel.salesNum];
    }
    
}
- (IBAction)addBuyCarAction:(UIButton *)sender {
//    [self.delegate goBuyCarWithCell:self];
}

- (IBAction)goodsDetailAction:(UIButton *)sender {
    [self.delegate goGoodsDetailWithCell:self];
}
@end
