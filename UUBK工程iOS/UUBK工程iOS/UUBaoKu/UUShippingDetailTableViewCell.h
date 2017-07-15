//
//  UUShippingDetailTableViewCell.h
//  UUBaoKu
//
//  Created by dev on 17/3/15.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUShippingDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shippingImg;
@property (weak, nonatomic) IBOutlet UILabel *shippingNameLab;
@property (weak, nonatomic) IBOutlet UILabel *shippingCodeLab;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
