//
//  GrouplistCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"
@class GrouplistModel;

@interface GrouplistCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *groupIcon;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (nonatomic, strong) GrouplistModel *grouplistModel;
@end
