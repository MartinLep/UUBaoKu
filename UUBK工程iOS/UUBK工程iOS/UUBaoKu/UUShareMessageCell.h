//
//  UUShareMessageCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/26.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUShareMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventNum;
@property (weak, nonatomic) IBOutlet UILabel *eventNemLab;

@end
