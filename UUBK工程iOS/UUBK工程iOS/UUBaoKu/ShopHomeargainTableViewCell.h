//
//  ShopHomeargainTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/10/20.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopHomeargainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *helpBargainBtn;
@property (weak, nonatomic) IBOutlet UIButton *helpBargainBtn1;
@property (weak, nonatomic) IBOutlet UIButton *helpBargainBtn2;

@property (weak, nonatomic) IBOutlet UIButton *OrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *OrderBtn1;
@property (weak, nonatomic) IBOutlet UIButton *OrderBtn2;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage1;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage2;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *priceA;
@property (weak, nonatomic) IBOutlet UILabel *priceB;
@property (weak, nonatomic) IBOutlet UILabel *priceC;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle1;
@property (weak, nonatomic) IBOutlet UILabel *goodsName1;
@property (weak, nonatomic) IBOutlet UILabel *priceA1;
@property (weak, nonatomic) IBOutlet UILabel *priceB1;
@property (weak, nonatomic) IBOutlet UILabel *priceC1;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle2;
@property (weak, nonatomic) IBOutlet UILabel *goodsName2;
@property (weak, nonatomic) IBOutlet UILabel *priceA2;
@property (weak, nonatomic) IBOutlet UILabel *priceB2;
@property (weak, nonatomic) IBOutlet UILabel *priceC2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
