//
//  UULinkTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/7.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UULinkTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shoppingName;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIImageView *img;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
