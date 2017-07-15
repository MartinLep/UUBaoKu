//
//  ShopHomeTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/10/19.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "ShopHomeTableViewCell.h"
//限时秒杀
@implementation ShopHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ShopHomecell";
    ShopHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell.goodsImagesArr = [NSArray arrayWithObjects:cell.image,cell.image1,cell.image2,nil];
        cell.priceAArr = [NSArray arrayWithObjects:cell.priceA,cell.priceA1,cell.priceA2, nil];
        cell.priceBArr = [NSArray arrayWithObjects:cell.priceB,cell.priceB1,cell.priceB2,nil];
        cell.goodsTitlesArr = [ NSArray arrayWithObjects:cell.goodsTitle,cell.goodTitle1,cell.goodsTitle2, nil];
        cell.goodsNamesArr = [NSArray arrayWithObjects:cell.goodsName,cell.goodsName1,cell.goodsName2, nil];
        cell = [[NSBundle mainBundle] loadNibNamed:@"ShopHomeTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
