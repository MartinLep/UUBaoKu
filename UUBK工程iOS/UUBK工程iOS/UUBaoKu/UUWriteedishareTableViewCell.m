//
//  UUWriteedishareTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/19.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUWriteedishareTableViewCell.h"

@implementation UUWriteedishareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //加入购物车
    self.addShopCar.layer.masksToBounds = YES;
    self.addShopCar.layer.cornerRadius = 2.5;
    //商品详情
    self.shoppingBtn.layer.masksToBounds = YES;
    self.shoppingBtn.layer.cornerRadius =2.5;
    [self.shoppingBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [self.shoppingBtn.layer setBorderWidth:1.5];//设置边界的宽度
    
    
    self.shoppingBtn.layer.borderColor=[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1].CGColor;

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUWriteedishareTableViewCell";
    UUWriteedishareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUWriteedishareTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}

@end
