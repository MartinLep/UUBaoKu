//
//  UUInitiatedPKTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/10/22.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUInitiatedPKTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lnitiatedPKImageView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
