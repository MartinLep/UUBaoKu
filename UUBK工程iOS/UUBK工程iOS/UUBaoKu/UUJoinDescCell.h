//
//  UUJoinDescCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUOtherGroupModel.h"

@protocol JoinedTeamDelegate <NSObject>

- (void)goToJoinTeamWithIndexPath:(NSIndexPath *)indexPath;

@end
@interface UUJoinDescCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *gradeLab;
@property (weak, nonatomic) IBOutlet UILabel *mobileLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *siTuanHaoLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (nonatomic,strong)UUOtherGroupModel *model;
@property (weak,nonatomic)id<JoinedTeamDelegate>delegate;
@end
