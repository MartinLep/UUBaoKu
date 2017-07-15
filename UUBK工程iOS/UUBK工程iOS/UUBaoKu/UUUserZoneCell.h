//
//  UUUserZoneCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUUserZoneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewWidth;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *levelDescLab;
@property(nonatomic,strong)NSString *userNameStr;
@property(nonatomic,strong)NSString *levelDescStr;
@property(nonatomic,strong)NSString *iconImgStr;
@end
