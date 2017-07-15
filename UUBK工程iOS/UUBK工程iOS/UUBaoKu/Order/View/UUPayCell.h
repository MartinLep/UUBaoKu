//
//  UUPayCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/11.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUPayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *payIcon;
@property (weak, nonatomic) IBOutlet UILabel *payName;
@property (weak, nonatomic) IBOutlet UIButton *paySelectedBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;

@end
