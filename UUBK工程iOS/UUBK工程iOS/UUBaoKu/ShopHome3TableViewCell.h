//
//  ShopHome3TableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/10/19.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopHome3TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage1;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *priceA;
@property (weak, nonatomic) IBOutlet UILabel *priceB;
@property (weak, nonatomic) IBOutlet UILabel *buyNum;
@property (weak, nonatomic) IBOutlet UILabel *priceC;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle1;
@property (weak, nonatomic) IBOutlet UILabel *priceA1;
@property (weak, nonatomic) IBOutlet UILabel *priceB1;
@property (weak, nonatomic) IBOutlet UILabel *priceC1;
@property (weak, nonatomic) IBOutlet UILabel *buyNum1;
@property (weak, nonatomic) IBOutlet UILabel *goodsName1;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
