//
//  UUSellWillTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/19.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUSellWillTableViewCell.h"
#import "UUHotArticles.h"
#import "UUMessageGoods.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@implementation UUSellWillTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.moreDataBtn.hidden = YES;
    CGFloat goodImageW = ([UIScreen mainScreen].bounds.size.width-24-50)/3;
    self.goodsimg1.frame = CGRectMake(12, 210, goodImageW, goodImageW);
    self.goodsimg2.frame = CGRectMake(12+25+goodImageW, 210, goodImageW, goodImageW);
    self.goodsimg3.frame = CGRectMake(12+50+2*goodImageW, 210, goodImageW, goodImageW);
}

- (void)setModel:(UUHotArticles *)model{
    _model = model;
    UUMessageGoods *goodsModel = [[UUMessageGoods alloc]initWithDict:_model.goodsList[0]];
    self.words.text = goodsModel.goodsName;
    self.sellWillRecommendType.text = _model.recommendType.integerValue==1?@"体验推荐":@"第六感推荐";
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:_model.userIcon] placeholderImage:HolderImage];
    self.userName.text = _model.userName;
    self.create_time.text = _model.createTimeFormat;
    self.commentsNum.text =KString(_model.commentsNum);
    self.likeNum.text =KString(_model.likesNum);
    if (_model.imgs.count >= 3) {
        [self.goodsimg1 sd_setImageWithURL:[NSURL URLWithString:_model.imgs[0]] placeholderImage:PLACEHOLDIMAGE];
        [self.goodsimg2 sd_setImageWithURL:[NSURL URLWithString:_model.imgs[1]] placeholderImage:PLACEHOLDIMAGE];
        [self.goodsimg3 sd_setImageWithURL:[NSURL URLWithString:_model.imgs[2]] placeholderImage:PLACEHOLDIMAGE];
    }else if (_model.imgs.count == 2){
        [self.goodsimg1 sd_setImageWithURL:[NSURL URLWithString:_model.imgs[0]] placeholderImage:PLACEHOLDIMAGE];
        [self.goodsimg2 sd_setImageWithURL:[NSURL URLWithString:_model.imgs[1]] placeholderImage:PLACEHOLDIMAGE];
    }else{
        [self.goodsimg1 sd_setImageWithURL:[NSURL URLWithString:_model.imgs[0]] placeholderImage:PLACEHOLDIMAGE];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUSellWillTableViewCell";
    UUSellWillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUSellWillTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
