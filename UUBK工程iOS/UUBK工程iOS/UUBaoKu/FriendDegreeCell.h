//
//  FriendDegreeCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"

@interface FriendDegreeCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *degreeSepIcon;
@property (weak, nonatomic) IBOutlet UIImageView *friendDegreeLogo;
@property (weak, nonatomic) IBOutlet UILabel *degreeTitle;
@property (weak, nonatomic) IBOutlet UILabel *degreeDesc;

@end
