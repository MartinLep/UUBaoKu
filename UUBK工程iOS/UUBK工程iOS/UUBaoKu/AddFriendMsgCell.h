//
//  AddFriendMsgCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"
#import "AddMsgModel.h"
@class AddFriendMsgCell;
@protocol AddFriendMsgCellDelegate<NSObject>
- (void)ChangeStateWithButton:(UIButton *)sender Cell:(AddFriendMsgCell *)cell;
@end

@interface AddFriendMsgCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UIButton *accepBtn;
@property (weak, nonatomic) IBOutlet UILabel *descr;
@property (weak, nonatomic) IBOutlet UIButton *msgStateBtn;
@property (nonatomic, strong) AddMsgModel *addMsgModel;
@property (nonatomic, weak) id<AddFriendMsgCellDelegate>delegate;
@end
