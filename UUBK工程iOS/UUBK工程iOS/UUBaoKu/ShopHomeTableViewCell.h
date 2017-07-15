//
//  ShopHomeTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/10/19.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
//限时秒杀
@interface ShopHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;

@property (weak, nonatomic) IBOutlet UILabel *priceA;
@property (weak, nonatomic) IBOutlet UILabel *priceB;
@property (weak, nonatomic) IBOutlet UILabel *priceA1;
@property (weak, nonatomic) IBOutlet UILabel *priceB1;
@property (weak, nonatomic) IBOutlet UILabel *priceA2;
@property (weak, nonatomic) IBOutlet UILabel *priceB2;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodTitle1;
@property (weak, nonatomic) IBOutlet UILabel *goodsName1;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle2;
@property (weak, nonatomic) IBOutlet UILabel *goodsName2;

@property(strong,nonatomic)NSArray *goodsImagesArr;
@property(strong,nonatomic)NSArray *priceAArr;
@property(strong,nonatomic)NSArray *priceBArr;
@property(strong,nonatomic)NSArray *goodsTitlesArr;
@property(strong,nonatomic)NSArray *goodsNamesArr;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
