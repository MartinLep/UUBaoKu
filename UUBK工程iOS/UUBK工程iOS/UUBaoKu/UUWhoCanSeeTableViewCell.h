//
//  UUWhoCanSeeTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUWhoCanSeeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *SelectImage;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (strong,nonatomic)NSString  *groupId;
@property (weak, nonatomic) IBOutlet UIButton *selecTedBtn;




+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
