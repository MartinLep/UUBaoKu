//
//  GroupSwitchCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"
@protocol GroupSwitchCellDelegate<NSObject>
- (void)MsgNoDisturb:(UISwitch *)sender;
@end
@interface GroupSwitchCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (nonatomic, weak) id<GroupSwitchCellDelegate>delegate;
@end
