//
//  UUattentionTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/7.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUattentionTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *SelectBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *attentionImg;






+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
