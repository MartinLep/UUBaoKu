//
//  UUaddaimsTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/12/21.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUaddaimsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *addAimsicon;
@property (weak, nonatomic) IBOutlet UILabel *userName;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
