//
//  UUSurePKTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/10/22.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUSurePKTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *SurePkimageView;
@property (weak, nonatomic) IBOutlet UIButton *surePKBtn;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
