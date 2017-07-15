//
//  UUMyLineTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/10/22.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUMyLineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *userName;
//@property (weak, nonatomic) IBOutlet UILabel *userDesc;
@property (weak, nonatomic) IBOutlet UILabel *myLineDesc;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;


@property(strong,nonatomic)NSString *userDesc;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
