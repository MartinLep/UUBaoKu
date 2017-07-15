//
//  ShopHome2TableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/10/19.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopHome2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsName;

@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UILabel *superPrice;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName1;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice1;
@property (weak, nonatomic) IBOutlet UILabel *superPrice1;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage1;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
