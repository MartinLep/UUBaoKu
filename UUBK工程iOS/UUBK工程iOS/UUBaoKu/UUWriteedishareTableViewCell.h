//
//  UUWriteedishareTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/19.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUWriteedishareTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addShopCar;
@property (weak, nonatomic) IBOutlet UIButton *shoppingBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *saleNum;






+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
