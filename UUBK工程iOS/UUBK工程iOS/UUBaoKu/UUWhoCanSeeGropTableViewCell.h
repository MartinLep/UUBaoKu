//
//  UUWhoCanSeeGropTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 17/1/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUWhoCanSeeGropTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *WhocanseeGroopname;
@property (weak, nonatomic) IBOutlet UIImageView *GroopselectedBtn;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
